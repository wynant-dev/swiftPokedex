//
//  LocalizedNameResolver.swift
//  SwiftPokedex
//

import Foundation

enum LocalizedNameResolver {
    static func displayName(
        from names: [LocalizedNameDTO],
        preferredLanguageCodes: [String] = Locale.preferredLanguages,
        fallback: String
    ) -> String {
        let languageCodes = preferredLanguageCodes.map { code in
            code.split(separator: "-").first.map(String.init) ?? code
        }

        for code in languageCodes {
            if let match = names.first(where: { $0.language.name.lowercased() == code.lowercased() }) {
                return match.name
            }
        }

        if let english = names.first(where: { $0.language.name.lowercased() == "en" }) {
            return english.name
        }

        return names.first?.name ?? fallback
    }
}
