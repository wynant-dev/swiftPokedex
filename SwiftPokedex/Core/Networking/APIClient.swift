//
//  APIClient.swift
//  SwiftPokedex
//

import Foundation

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError(transport: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.transport("Invalid server response.")
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
