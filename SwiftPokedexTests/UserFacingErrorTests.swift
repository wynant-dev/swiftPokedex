//
//  UserFacingErrorTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class UserFacingErrorTests: XCTestCase {
    func testMessageIncludesHTTPStatusCode() {
        let message = UserFacingError.message(
            for: APIError.httpError(statusCode: 404),
            decodingContext: "data"
        )
        XCTAssertTrue(message.contains("404"))
    }

    func testMessageIsNonEmptyForDecodingFailure() {
        let message = UserFacingError.message(
            for: APIError.decodingFailed,
            decodingContext: "generation data"
        )
        XCTAssertFalse(message.isEmpty)
    }
}
