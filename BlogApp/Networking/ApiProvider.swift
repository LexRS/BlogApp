//
//  ApiProvider.swift
//  BlogApp
//
//  Created by Алексей Поддубный on 07.03.2026.
//

import Foundation
import AuthSDK
import Core

class DefaultApiProvider: ApiProvider {
    private let config: ConfigProtocol
    private let sessionProvider: SessionProviderProtocol
    private let session: URLSession
    
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
        let (data, response) = try await session.data(for: request)
        
        // Handle 401 unauthorized - If token expired
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            // TODO: -  Update token logic here
            // You could implement token refresh logic here
            // For example, call a refresh endpoint and update sessionKeeper
            // Then retry the request once
            throw ApiError.unauthorized
        }
        
        // Check for empty response (204 No Content)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 204 {
            // Return empty instance for EmptyResponse type
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            // If expecting non-empty but got 204, throw error
            throw ApiError.unexpectedEmptyResponse
        }
        
        // Handle cases where data might be empty
        guard !data.isEmpty else {
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            throw ApiError.emptyData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            throw ApiError.decodingError
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
}

private extension ApiProvider {
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
