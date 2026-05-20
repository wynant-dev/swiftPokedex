//
//  GenerationEndpoints.swift
//  SwiftPokedex
//

import Foundation

enum GenerationEndpoints {
    static func generations() throws -> URL {
        try APIConfiguration.url(path: "generation")
    }
}
