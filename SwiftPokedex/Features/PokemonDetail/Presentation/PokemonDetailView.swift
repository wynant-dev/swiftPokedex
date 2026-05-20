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

            if viewModel.isLoading {
                ProgressView()
            }

            if let pokemon = viewModel.pokemonDetail {
                Text(pokemon.name)
                Text(pokemon.id.description)
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
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
