//
//  Networking.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import Foundation

enum NetworkingError: Error {
    case missingData
    case decodingFailed(Error)
}

protocol Networking: AnyObject {
    func loadImages(page: Int) async throws -> ImagesListResponse
}

final class HTTPClient: Networking {
    private let session: URLSession

    init() {
        self.session = URLSession.shared
    }

    func loadImages(page: Int) async throws -> ImagesListResponse {
        var components = URLComponents(string: "https://api.pexels.com/v1/curated")!
        components.queryItems = [
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        var urlRequest = URLRequest(url: components.url!)

        urlRequest.httpMethod = "GET"
        urlRequest.setValue(
            "uXAeKSWY5Sg53ZD67dl5ziq9KOz8a47DjIyIuOiHQp5JrK5ZdpBi2ovc",
            forHTTPHeaderField: "Authorization"
        )

        return try await load(urlRequest: urlRequest)
    }

    private func load<Response: Decodable>(urlRequest: URLRequest) async throws -> Response {
        guard let (data, response) = try? await session.data(for: urlRequest),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkingError.missingData
        }

        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw NetworkingError.decodingFailed(error)
        }
    }
}
