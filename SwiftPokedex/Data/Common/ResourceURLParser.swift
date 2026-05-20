//
//  ResourceURLParser.swift
//  SwiftPokedex
//

import Foundation

enum ResourceURLParser {
    static func id(from urlString: String) throws -> Int {
        guard let url = URL(string: urlString),
              let idString = url.pathComponents.last(where: { !$0.isEmpty }),
              let id = Int(idString)
        else {
            throw APIError.decodingFailed
        }
        return id
    }
}
