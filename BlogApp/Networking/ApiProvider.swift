//
//  ApiProvider.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.03.2026.
//

import Foundation
import AuthSDK
import Core

class DefaultApiProvider: ApiProviderProtocol {
    private let config: ConfigProtocol
    private let sessionProvider: SessionProviderProtocol
    private let session: URLSession
    
    // Add a lock to prevent multiple simultaneous refresh attempts
    private let refreshLock = NSLock()
    private var isRefreshing = false
    private var pendingRequests: [(URLRequest) -> Void] = []
    
    init(
        config: ConfigProtocol,
        sessionProvider: SessionProviderProtocol,
        session: URLSession = .shared
    ) {
        self.config = config
        self.sessionProvider = sessionProvider
        self.session = session
    }
    
    func request<T>(_ router: any ApiRouter) async throws -> T where T : Decodable {
        let request = try await buildRequest(router)
        let authorizedRequest = try await sessionProvider.authorize(request)
        
        #if DEBUG
        await printCurl(request: authorizedRequest, includeHeaders: true, includeBody: true)
        #endif
        do {
            let (data, response) = try await session.data(for: authorizedRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                // Handle 401 - token expired
                if httpResponse.statusCode == 401 {
                    // Try to refresh token and retry request
                    let retryRequest = try await refreshAndRetry(request)
                    let (retryData, retryResponse) = try await session.data(for: retryRequest)
                    
                    if let retryHttpResponse = retryResponse as? HTTPURLResponse,
                       retryHttpResponse.statusCode == 401 {
                        // Refresh failed - clear session and throw
                        await sessionProvider.clearSession()
                        throw ApiError.unauthorized
                    }
                    
                    return try handleResponse(data: retryData, response: retryResponse)
                }
            }
            
            return try handleResponse(data: data, response: response)
        
        } catch {
            // Handle network errors
            throw error
        }
    }
    
    private func buildRequest(_ router: ApiRouter) throws -> URLRequest {
        guard var components = URLComponents(string: config.baseUrl + router.path ) else {
            throw ApiError.invalidURL
        }
        
        components.queryItems = router.query
        
        guard let url = components.url else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        request.httpBody = router.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    // MARK: - Token Refresh Logic
    private func refreshAndRetry(_ originalRequest: URLRequest) async throws -> URLRequest {
        // Check if we're already refreshing
        if isRefreshing {
            // Wait for the ongoing refresh to complete
            return try await withCheckedThrowingContinuation { continuation in
                refreshLock.lock()
                pendingRequests.append { newRequest in
                    continuation.resume(returning: newRequest)
                }
                refreshLock.unlock()
            }
        }
        
        // Start refresh process
        refreshLock.lock()
        isRefreshing = true
        refreshLock.unlock()
        
        defer {
            refreshLock.lock()
            isRefreshing = false
            pendingRequests.removeAll()
            refreshLock.unlock()
        }
        
        // Get the refresh token
        guard let refreshToken = await sessionProvider.refreshToken() else {
            throw ApiError.unauthorized
        }
        
        // Build refresh request
        let refreshRequest = try buildRefreshRequest(refreshToken: refreshToken)
        let (data, response) = try await session.data(for: refreshRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // Refresh failed - clear session
            await sessionProvider.clearSession()
            throw ApiError.unauthorized
        }
        
        // Decode new tokens
        let newSession = try JSONDecoder().decode(Session.self, from: data)
        await sessionProvider.saveSession(newSession)
        
        // Create new authorized request with new token
        let newAuthorizedRequest = try await sessionProvider.authorize(originalRequest)
        
        // Complete pending requests with the new authorization
        let pendingRequestsCopy: [(URLRequest) -> Void]
        refreshLock.lock()
        pendingRequestsCopy = pendingRequests
        refreshLock.unlock()
        
        for completion in pendingRequestsCopy {
            completion(newAuthorizedRequest)
        }
        
        return newAuthorizedRequest
    }
    
    // TODO: - All routing logic should be in router
    private func buildRefreshRequest(refreshToken: String) throws -> URLRequest {
        guard let url = URL(string: config.baseUrl + "/refresh") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        return request
    }

    
    // MARK: - Response Handling
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 204 {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                throw ApiError.unexpectedEmptyResponse
            }
            
            guard !data.isEmpty else {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                throw ApiError.emptyData
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            } catch {
                throw ApiError.decodingError
            }
        }
}

private extension ApiProviderProtocol {
    func printCurl(request: URLRequest, includeHeaders: Bool = true, includeBody: Bool = true) {
        var components = ["curl -v"]
        
        // Add HTTP method
        if let httpMethod = request.httpMethod {
            components.append("-X \(httpMethod)")
        }
        
        // Add headers
        if includeHeaders, let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                // Escape quotes in header values
                let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
                components.append("-H \"\(key): \(escapedValue)\"")
            }
        }
        
        // Add body
        if includeBody, let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            // Try to pretty print JSON body if it's JSON
            if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                
                // Escape the JSON string for curl
                let escapedBody = prettyString
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")
                components.append("-d \"\(escapedBody)\"")
            } else {
                // For non-JSON bodies
                let escapedBody = bodyString
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")
                components.append("-d \"\(escapedBody)\"")
            }
        }
        
        // Add URL
        if let url = request.url?.absoluteString {
            components.append("\"\(url)\"")
        }
        
        // Print the curl command
        let curlCommand = components.joined(separator: " ")
        print("🔗 \(curlCommand)")
    }
}

public struct EmptyResponse: Decodable {
    public init() {}
}
