//
//  PokemonDetailViewModel.swift
//  SwiftPokedex
//

internal import Combine
import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var state: LoadState<PokemonDetail> = .idle

    private let repository: any PokemonRepositoryProtocol
    private let loadRunner = LoadTaskRunner()

    init(repository: any PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func loadPokemon(name: String) {
        loadRunner.run(
            decodingContext: L10n.Error.contextPokemonData,
            getState: { [weak self] in self?.state ?? .idle },
            setState: { [weak self] in self?.state = $0 },
            operation: { [repository] in try await repository.pokemon(named: name) }
        )
    }
}
