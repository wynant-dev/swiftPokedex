//
//  LoadTaskRunnerTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

@MainActor
final class LoadTaskRunnerTests: XCTestCase {
    func testRunSuccessSetsLoadedState() async {
        let runner = LoadTaskRunner()
        var state: LoadState<Int> = .idle

        runner.run(
            getState: { state },
            setState: { state = $0 },
            operation: { 42 }
        )
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(state, .loaded(42))
    }

    func testRunFailureSetsFailedState() async {
        let runner = LoadTaskRunner()
        var state: LoadState<Int> = .idle

        runner.run(
            decodingContext: "test data",
            getState: { state },
            setState: { state = $0 },
            operation: { throw APIError.httpError(statusCode: 500) }
        )
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(state, .failed("Server error (500)."))
    }

    func testRunFailureKeepsStaleLoadedValue() async {
        let runner = LoadTaskRunner()
        var state: LoadState<Int> = .loaded(1)

        runner.run(
            getState: { state },
            setState: { state = $0 },
            operation: { throw APIError.httpError(statusCode: 500) }
        )
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(state, .loaded(1))
    }
}
