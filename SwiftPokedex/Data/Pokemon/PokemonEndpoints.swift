//
//  PokemonEndpoints.swift
//  SwiftPokedex
//

import Foundation

enum PokemonEndpoints {
    static func pokemon(named name: String) throws -> URL {
        try APIConfiguration.url(path: "pokemon/\(name)")
    }

    static func pokemon(number: Int) throws -> URL {
        try APIConfiguration.url(path: "pokemon/\(number)")
    }
}
