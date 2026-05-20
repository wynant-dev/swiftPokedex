//
//  SlugDisplayNameFormatter.swift
//  SwiftPokedex
//

enum SlugDisplayNameFormatter {
    /// Builds a readable label from an API slug until localized names are loaded.
    static func humanized(_ slug: String) -> String {
        slug
            .split(separator: "-")
            .map(\.capitalized)
            .joined(separator: " ")
    }
}
