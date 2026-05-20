//
//  PokemonDetailViewModel.swift
//  SwiftPokedex
//

internal import Combine
import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: any PokemonRepositoryProtocol
    private var loadTask: Task<Void, Never>?

    init(repository: any PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func loadPokemon(name: String) {
        loadTask?.cancel()
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }

            do {
                let result = try await repository.pokemon(named: name)
                guard !Task.isCancelled else { return }
                pokemonDetail = result
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = PokemonDetailError(underlying: error).userMessage
            }
        }
    }
}
