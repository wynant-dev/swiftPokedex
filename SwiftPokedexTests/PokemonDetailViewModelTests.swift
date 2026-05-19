//
//  PokemonDetailViewModelTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

@MainActor
final class PokemonDetailViewModelTests: XCTestCase {
    func testLoadPokemonSuccessSetsDetail() async {
        let repository = MockPokemonRepository()
        repository.result = .success(PokemonDetail(id: 25, name: "PIKACHU"))
        let viewModel = PokemonDetailViewModel(repository: repository)

        viewModel.loadPokemon(name: "pikachu")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.pokemonDetail, PokemonDetail(id: 25, name: "PIKACHU"))
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadPokemonFailureSetsErrorMessage() async {
        let repository = MockPokemonRepository()
        repository.result = .failure(APIError.httpError(statusCode: 404))
        let viewModel = PokemonDetailViewModel(repository: repository)

        viewModel.loadPokemon(name: "unknown")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNil(viewModel.pokemonDetail)
        XCTAssertEqual(viewModel.errorMessage, "Server error (404).")
        XCTAssertFalse(viewModel.isLoading)
    }
}
