//
//  PokemonDetailViewModelTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

@MainActor
final class PokemonDetailViewModelTests: XCTestCase {
    func testLoadPokemonSuccessSetsLoadedState() async {
        let repository = MockPokemonRepository()
        repository.result = .success(PokemonDetail(id: 25, name: "PIKACHU"))
        let viewModel = PokemonDetailViewModel(repository: repository)

        viewModel.loadPokemon(name: "pikachu")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.state, .loaded(PokemonDetail(id: 25, name: "PIKACHU")))
    }

    func testLoadPokemonFailureSetsFailedState() async {
        let repository = MockPokemonRepository()
        repository.result = .failure(APIError.httpError(statusCode: 404))
        let viewModel = PokemonDetailViewModel(repository: repository)

        viewModel.loadPokemon(name: "unknown")
        try? await Task.sleep(nanoseconds: 100_000_000)

        guard case let .failed(message) = viewModel.state else {
            return XCTFail("Expected failed state")
        }
        XCTAssertTrue(message.contains("404"))
    }
}
