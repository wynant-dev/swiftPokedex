//
//  GenerationEndpoints.swift
//  SwiftPokedex
//

import Foundation

enum GenerationEndpoints {
    static func generations() throws -> URL {
        try APIConfiguration.url(path: "generation")
    }

    static func generation(id: Int) throws -> URL {
        try APIConfiguration.url(path: "generation/\(id)")
    }
}
