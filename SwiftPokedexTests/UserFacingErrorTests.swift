//
//  UserFacingErrorTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class UserFacingErrorTests: XCTestCase {
    func testMessageMapsAPIError() {
        XCTAssertEqual(
            UserFacingError.message(for: APIError.httpError(statusCode: 404)),
            "Server error (404)."
        )
    }

    func testMessageUsesDecodingContext() {
        XCTAssertEqual(
            UserFacingError.message(for: APIError.decodingFailed, decodingContext: "generation data"),
            "Could not read generation data."
        )
    }
}
