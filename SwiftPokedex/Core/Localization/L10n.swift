//
//  L10n.swift
//  SwiftPokedex
//
//  UI strings from Localizable.xcstrings (en, fr, de).
//

import Foundation

enum L10n {
    enum Generations {
        static var title: String {
            String(localized: "generations.title")
        }

        static var loadFailedTitle: String {
            String(localized: "generations.load_failed.title")
        }

        static var retry: String {
            String(localized: "generations.retry")
        }

        static func count(_ count: Int) -> String {
            String(format: String(localized: "generations.count"), locale: .current, count)
        }
    }

    enum PokemonDetail {
        static var namePlaceholder: String {
            String(localized: "pokemon_detail.name_placeholder")
        }

        static var fetch: String {
            String(localized: "pokemon_detail.fetch")
        }

        static func idLabel(formattedNumber: String) -> String {
            String(format: String(localized: "pokemon_detail.id_label"), locale: .current, formattedNumber)
        }

        static func height(formattedMeasurement: String) -> String {
            String(format: String(localized: "pokemon_detail.height"), locale: .current, formattedMeasurement)
        }
    }

    enum Error {
        static var invalidRequest: String {
            String(localized: "error.invalid_request")
        }

        static func http(statusCode: Int) -> String {
            String(format: String(localized: "error.http"), locale: .current, statusCode)
        }

        static func decodingFailed(context: String) -> String {
            String(format: String(localized: "error.decoding_failed"), locale: .current, context)
        }

        static var contextGenerationData: String {
            String(localized: "error.context.generation_data")
        }

        static var contextPokemonData: String {
            String(localized: "error.context.pokemon_data")
        }
    }
}
