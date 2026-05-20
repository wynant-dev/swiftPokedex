//
//  GenerationListViewModel.swift
//  SwiftPokedex
//

internal import Combine
import Foundation

@MainActor
final class GenerationListViewModel: ObservableObject {
    @Published var state: LoadState<[Generation]> = .idle

    private let repository: any GenerationListRepositoryProtocol
    private let loadRunner = LoadTaskRunner()

    init(repository: any GenerationListRepositoryProtocol) {
        self.repository = repository
    }

    func loadGenerations() {
        loadRunner.run(
            decodingContext: L10n.Error.contextGenerationData,
            getState: { [weak self] in self?.state ?? .idle },
            setState: { [weak self] in self?.state = $0 },
            operation: { [repository] in try await repository.fetchGenerations() }
        )
    }
}
