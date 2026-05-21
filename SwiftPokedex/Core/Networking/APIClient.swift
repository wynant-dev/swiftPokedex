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
        let startedAt = Date()
        AppLog.network("fetch started | url=\(url.absoluteString) type=\(T.self)")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            AppLog.network("fetch failed | url=\(url.absoluteString) error=\(error)")
            throw APIError(transport: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            AppLog.network("fetch failed | url=\(url.absoluteString) error=invalid_response")
            throw APIError.transport("Invalid server response.")
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            AppLog.network("fetch failed | url=\(url.absoluteString) status=\(httpResponse.statusCode)")
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            let value = try decoder.decode(T.self, from: data)
            let durationMs = Int(Date().timeIntervalSince(startedAt) * 1000)
            AppLog.network("fetch succeeded | url=\(url.absoluteString) durationMs=\(durationMs)")
            return value
        } catch {
            AppLog.network("fetch failed | url=\(url.absoluteString) error=decoding")
            throw APIError.decodingFailed
        }
    }
}
