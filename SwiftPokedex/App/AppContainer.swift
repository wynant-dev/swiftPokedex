//
//  AppContainer.swift
//  SwiftPokedex
//

import Foundation

final class AppContainer {
    private let apiClient: any APIClientProtocol
    private let pokemonRepository: any PokemonRepositoryProtocol
    private let generationListRepository: any GenerationListRepositoryProtocol

    init(
        apiClient: any APIClientProtocol = APIClient(),
        pokemonRepository: (any PokemonRepositoryProtocol)? = nil,
        generationListRepository: (any GenerationListRepositoryProtocol)? = nil
    ) {
        self.apiClient = apiClient
        self.pokemonRepository = pokemonRepository ?? RemotePokemonRepository(client: apiClient)
        self.generationListRepository = generationListRepository
            ?? RemoteGenerationRepository(client: apiClient)
    }

    @MainActor
    func makePokemonDetailViewModel() -> PokemonDetailViewModel {
        PokemonDetailViewModel(repository: pokemonRepository)
    }

    @MainActor
    func makeGenerationListViewModel() -> GenerationListViewModel {
        GenerationListViewModel(repository: generationListRepository)
    }
}
