//
//  LocaleFormattingTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class LocaleFormattingTests: XCTestCase {
    func testFormattedIntegerUsesLocaleAwareSeparator() {
        let us = formattedInteger(1234, locale: Locale(identifier: "en_US"))
        let fr = formattedInteger(1234, locale: Locale(identifier: "fr_FR"))

        XCTAssertEqual(us, "1,234")
        XCTAssertTrue(fr.contains("234"))
        XCTAssertNotEqual(us, fr)
    }

    func testFormattedHeightProducesNonEmptyValue() {
        XCTAssertFalse(
            formattedHeight(meters: 1.7, locale: Locale(identifier: "fr_FR")).isEmpty
        )
    }

    private func formattedInteger(_ value: Int, locale: Locale) -> String {
        value.formatted(.number.locale(locale))
    }

    private func formattedHeight(meters: Double, locale: Locale) -> String {
        Measurement(value: meters, unit: UnitLength.meters).formatted(
            .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.locale(locale)
            )
        )
    }
}
