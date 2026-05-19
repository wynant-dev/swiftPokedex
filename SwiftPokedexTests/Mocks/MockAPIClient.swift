//
//  MockAPIClient.swift
//  SwiftPokedexTests
//

import Foundation
@testable import SwiftPokedex

final class MockAPIClient: APIClientProtocol {
    var result: Result<any Decodable, Error> = .failure(APIError.decodingFailed)

    func fetch<T: Decodable>(_: URL) async throws -> T {
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
