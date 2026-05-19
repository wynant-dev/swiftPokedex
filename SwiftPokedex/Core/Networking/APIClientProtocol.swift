//
//  APIClientProtocol.swift
//  SwiftPokedex
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ url: URL) async throws -> T
}
