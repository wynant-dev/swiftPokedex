//
//  PokemonDetailView.swift
//  SwiftPokedex
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    @State private var name: String = "pikachu"

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            TextField("Pokemon name", text: $name)
                .textFieldStyle(.roundedBorder)

            Button("Fetch") {
                viewModel.loadPokemon(name: name)
            }

            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case let .loaded(pokemon):
                Text(pokemon.name)
                Text(pokemon.id.description)
            case let .failed(message):
                Text(message).foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            repository: PreviewPokemonRepository()
        )
    )
}

private final class PreviewPokemonRepository: PokemonRepositoryProtocol {
    func pokemon(named name: String) async throws -> PokemonDetail {
        PokemonDetail(id: 25, name: name.uppercased())
    }
}
