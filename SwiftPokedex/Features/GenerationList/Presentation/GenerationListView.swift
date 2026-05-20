//
//  GenerationListView.swift
//  SwiftPokedex
//

import SwiftUI

struct GenerationListView: View {
    @StateObject private var viewModel: GenerationListViewModel

    init(viewModel: GenerationListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                if viewModel.state.value == nil {
                    ProgressView()
                } else {
                    generationList(viewModel.state.value ?? [])
                }
            case let .loaded(generations):
                generationList(generations)
            case let .failed(message):
                if viewModel.state.value == nil {
                    ContentUnavailableView {
                        Label("Could not load generations", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            viewModel.loadGenerations()
                        }
                    }
                } else {
                    generationList(viewModel.state.value ?? [])
                }
            }
        }
        .navigationTitle("Generations")
        .task {
            viewModel.loadGenerations()
        }
        .refreshable {
            viewModel.loadGenerations()
        }
    }

    private func generationList(_ generations: [Generation]) -> some View {
        List(generations) { generation in
            Text(generation.displayName)
        }
    }
}

#Preview {
    NavigationStack {
        GenerationListView(
            viewModel: GenerationListViewModel(
                repository: PreviewGenerationListRepository()
            )
        )
    }
}

private final class PreviewGenerationListRepository: GenerationListRepositoryProtocol {
    func fetchGenerations() async throws -> [Generation] {
        [
            Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: true),
            Generation(id: 2, slug: "generation-ii", displayName: "Generation II", isDisplayNameLocalized: true),
        ]
    }
}
