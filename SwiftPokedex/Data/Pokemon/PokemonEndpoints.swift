//
//  PokemonEndpoints.swift
//  SwiftPokedex
//

import Foundation

enum PokemonEndpoints {
    static let baseURL = "https://pokeapi.co/api/v2"

    static func pokemon(named name: String) throws -> URL {
        try makeURL(path: "pokemon/\(name)")
    }

    static func pokemon(number: Int) throws -> URL {
        try makeURL(path: "pokemon/\(number)")
    }

    private static func makeURL(path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw APIError.invalidURL
        }
        return url
    }
}
