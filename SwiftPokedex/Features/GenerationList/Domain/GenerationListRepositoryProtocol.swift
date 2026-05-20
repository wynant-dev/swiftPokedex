//
//  GenerationListRepositoryProtocol.swift
//  SwiftPokedex
//

protocol GenerationListRepositoryProtocol {
    func fetchGenerations() async throws -> [Generation]
}
