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
                        Label(L10n.Generations.loadFailedTitle, systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button(L10n.Generations.retry) {
                            viewModel.loadGenerations()
                        }
                    }
                } else {
                    generationList(viewModel.state.value ?? [])
                }
            }
        }
        .navigationTitle(L10n.Generations.title)
        .task {
            viewModel.loadGenerations()
        }
        .refreshable {
            viewModel.loadGenerations()
        }
    }

    private func generationList(_ generations: [Generation]) -> some View {
        List {
            Section {
                ForEach(generations) { generation in
                    Text(generation.displayName)
                }
            } footer: {
                Text(L10n.Generations.count(generations.count))
            }
        }
    }
}

#Preview("French") {
    NavigationStack {
        GenerationListView(
            viewModel: GenerationListViewModel(repository: PreviewGenerationListRepository())
        )
    }
    .environment(\.locale, Locale(identifier: "fr"))
}

private final class PreviewGenerationListRepository: GenerationListRepositoryProtocol {
    func fetchGenerations() async throws -> [Generation] {
        [
            Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: true),
            Generation(id: 2, slug: "generation-ii", displayName: "Generation II", isDisplayNameLocalized: true)
        ]
    }
}
