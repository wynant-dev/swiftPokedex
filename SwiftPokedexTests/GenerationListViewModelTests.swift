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
            Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: true),
            Generation(id: 2, slug: "generation-ii", displayName: "Generation II", isDisplayNameLocalized: true)
        ])
        let viewModel = GenerationListViewModel(repository: repository)

        viewModel.loadGenerations()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(
            viewModel.state,
            .loaded([
                Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: true),
                Generation(id: 2, slug: "generation-ii", displayName: "Generation II", isDisplayNameLocalized: true)
            ])
        )
    }

    func testLoadGenerationsFailureSetsFailedState() async {
        let repository = MockGenerationListRepository()
        repository.result = .failure(APIError.httpError(statusCode: 500))
        let viewModel = GenerationListViewModel(repository: repository)

        viewModel.loadGenerations()
        try? await Task.sleep(nanoseconds: 100_000_000)

        guard case let .failed(message) = viewModel.state else {
            return XCTFail("Expected failed state")
        }
        XCTAssertTrue(message.contains("500"))
    }
}
