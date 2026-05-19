//
//  PokemonDetailError.swift
//  SwiftPokedex
//

import Foundation

enum PokemonDetailError: Error {
    case loadFailed(APIError)
    case unknown(String)

    var userMessage: String {
        switch self {
        case let .loadFailed(apiError):
            switch apiError {
            case .invalidURL:
                "Invalid request."
            case let .httpError(statusCode):
                "Server error (\(statusCode))."
            case .decodingFailed:
                "Could not read Pokémon data."
            case let .transport(message):
                message
            }
        case let .unknown(message):
            message
        }
    }
}

extension PokemonDetailError {
    init(underlying error: Error) {
        if let apiError = error as? APIError {
            self = .loadFailed(apiError)
        } else {
            self = .unknown(error.localizedDescription)
        }
    }
}
