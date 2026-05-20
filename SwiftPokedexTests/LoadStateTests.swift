//
//  LoadStateTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class LoadStateTests: XCTestCase {
    func testValueReturnsLoadedContent() {
        let state = LoadState.loaded("hello")
        XCTAssertEqual(state.value, "hello")
    }

    func testFailedExposesErrorMessage() {
        let state = LoadState<String>.failed("Oops")
        XCTAssertEqual(state.errorMessage, "Oops")
        XCTAssertNil(state.value)
    }

    func testLoadingIsLoading() {
        XCTAssertTrue(LoadState<String>.loading.isLoading)
        XCTAssertFalse(LoadState<String>.idle.isLoading)
    }
}
