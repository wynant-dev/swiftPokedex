//
//  LocalizedNameResolverTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class LocalizedNameResolverTests: XCTestCase {
    func testDisplayNamePrefersMatchingLanguage() {
        let names = [
            LocalizedNameDTO(
                language: NamedResourceDTO(name: "fr", url: "https://pokeapi.co/api/v2/language/5/"),
                name: "1re Génération"
            ),
            LocalizedNameDTO(
                language: NamedResourceDTO(name: "en", url: "https://pokeapi.co/api/v2/language/9/"),
                name: "Generation I"
            )
        ]

        let displayName = LocalizedNameResolver.displayName(
            from: names,
            preferredLanguageCodes: ["en-US"],
            fallback: "Fallback"
        )

        XCTAssertEqual(displayName, "Generation I")
    }

    func testDisplayNameUsesFallbackWhenNoMatch() {
        let displayName = LocalizedNameResolver.displayName(
            from: [],
            preferredLanguageCodes: ["en"],
            fallback: "Generation I"
        )

        XCTAssertEqual(displayName, "Generation I")
    }
}
