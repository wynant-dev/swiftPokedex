//
//  PokemonRepositoryProtocol.swift
//  SwiftPokedex
//

protocol PokemonRepositoryProtocol {
    func pokemon(named name: String) async throws -> PokemonDetail
}
