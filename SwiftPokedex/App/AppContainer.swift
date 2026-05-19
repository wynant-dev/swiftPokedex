//
//  AppContainer.swift
//  SwiftPokedex
//

import Foundation

final class AppContainer {
    private let apiClient: any APIClientProtocol
    private let pokemonRepository: any PokemonRepository

    init(
        apiClient: any APIClientProtocol = APIClient(),
        pokemonRepository: (any PokemonRepository)? = nil
    ) {
        self.apiClient = apiClient
        self.pokemonRepository = pokemonRepository ?? RemotePokemonRepository(client: apiClient)
    }

    @MainActor
    func makePokemonDetailViewModel() -> PokemonDetailViewModel {
        PokemonDetailViewModel(repository: pokemonRepository)
    }
}
