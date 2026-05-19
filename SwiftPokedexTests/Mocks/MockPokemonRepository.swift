//
//  MockPokemonRepository.swift
//  SwiftPokedexTests
//

import Foundation
@testable import SwiftPokedex

final class MockPokemonRepository: PokemonRepository {
    var result: Result<PokemonDetail, Error> = .success(PokemonDetail(id: 25, name: "PIKACHU"))

    func pokemon(named _: String) async throws -> PokemonDetail {
        switch result {
        case let .success(detail):
            return detail
        case let .failure(error):
            throw error
        }
    }
}
