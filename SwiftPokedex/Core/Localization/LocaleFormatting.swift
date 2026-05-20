//
//  LocaleFormatting.swift
//  SwiftPokedex
//
//  Locale-aware number and measurement formatting for UI.
//

import Foundation

enum LocaleFormatting {
    static func formattedInteger(_ value: Int) -> String {
        value.formatted(.number.locale(.current))
    }

    static func formattedDecimal(_ value: Double, fractionDigits: Int = 1) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(fractionDigits))
                .locale(.current)
        )
    }

    /// Formats a height in meters using the locale's measurement system (metric/imperial).
    static func formattedHeight(meters: Double) -> String {
        let measurement = Measurement(value: meters, unit: UnitLength.meters)
        return measurement.formatted(
            .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.locale(.current)
            )
        )
    }
}
