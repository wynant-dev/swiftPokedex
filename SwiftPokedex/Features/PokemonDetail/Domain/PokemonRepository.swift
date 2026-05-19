//
//  PokemonRepository.swift
//  SwiftPokedex
//

protocol PokemonRepository {
    func pokemon(named name: String) async throws -> PokemonDetail
}
