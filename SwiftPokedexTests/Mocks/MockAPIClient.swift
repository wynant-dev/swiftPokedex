//
//  MockAPIClient.swift
//  SwiftPokedexTests
//

import Foundation
@testable import SwiftPokedex

final class MockAPIClient: APIClientProtocol {
    var fetchHandler: ((URL) async throws -> any Decodable)?
    var result: Result<any Decodable, Error> = .failure(APIError.decodingFailed)

    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        if let fetchHandler {
            let value = try await fetchHandler(url)
            guard let typedValue = value as? T else {
                throw APIError.decodingFailed
            }
            return typedValue
        }

        switch result {
        case let .success(value):
            guard let typedValue = value as? T else {
                throw APIError.decodingFailed
            }
            return typedValue
        case let .failure(error):
            throw error
        }
    }
}
