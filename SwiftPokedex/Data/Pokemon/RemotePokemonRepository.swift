//
//  RemotePokemonRepository.swift
//  SwiftPokedex
//

final class RemotePokemonRepository: PokemonRepositoryProtocol {
    private let client: any APIClientProtocol

    init(client: any APIClientProtocol) {
        self.client = client
    }

    func pokemon(named name: String) async throws -> PokemonDetail {
        let url = try PokemonEndpoints.pokemon(named: name)
        let dto: PokemonDTO = try await client.fetch(url)
        return PokemonMapper.toDomain(dto)
    }
}
