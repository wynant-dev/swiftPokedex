//
//  APIConfiguration.swift
//  SwiftPokedex
//

import Foundation

enum APIConfiguration {
    static let baseURL = "https://pokeapi.co/api/v2"

    static func url(path: String) throws -> URL {
        let normalizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        guard let url = URL(string: "\(baseURL)/\(normalizedPath)") else {
            throw APIError.invalidURL
        }
        return url
    }
}
