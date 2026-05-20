//
//  GenerationListViewModelTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

@MainActor
final class GenerationListViewModelTests: XCTestCase {
    func testLoadGenerationsSuccessSetsLoadedState() async {
        let repository = MockGenerationListRepository()
        repository.result = .success([
            Generation(id: 1, name: "Generation I"),
            Generation(id: 2, name: "Generation II"),
        ])
        let viewModel = GenerationListViewModel(repository: repository)

        viewModel.loadGenerations()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(
            viewModel.state,
            .loaded([
                Generation(id: 1, name: "Generation I"),
                Generation(id: 2, name: "Generation II"),
            ])
        )
    }

    func testLoadGenerationsFailureSetsFailedState() async {
        let repository = MockGenerationListRepository()
        repository.result = .failure(APIError.httpError(statusCode: 500))
        let viewModel = GenerationListViewModel(repository: repository)

        viewModel.loadGenerations()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.state, .failed("Server error (500)."))
    }
}
