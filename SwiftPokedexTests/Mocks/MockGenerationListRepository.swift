//
//  MockGenerationListRepository.swift
//  SwiftPokedexTests
//

import Foundation
@testable import SwiftPokedex

final class MockGenerationListRepository: GenerationListRepositoryProtocol {
    var result: Result<[Generation], Error> = .success([
        Generation(id: 1, name: "Generation I"),
    ])

    func fetchGenerations() async throws -> [Generation] {
        switch result {
        case let .success(generations):
            return generations
        case let .failure(error):
            throw error
        }
    }
}
