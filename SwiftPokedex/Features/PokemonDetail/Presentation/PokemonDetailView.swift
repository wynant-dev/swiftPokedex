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
        VStack(alignment: .leading, spacing: 12) {
            TextField(L10n.PokemonDetail.namePlaceholder, text: $name)
                .textFieldStyle(.roundedBorder)

            Button(L10n.PokemonDetail.fetch) {
                viewModel.loadPokemon(name: name)
            }

            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case let .loaded(pokemon):
                Text(pokemon.name)
                Text(L10n.PokemonDetail.idLabel(formattedNumber: LocaleFormatting.formattedInteger(pokemon.id)))
                Text(L10n.PokemonDetail.height(formattedMeasurement: LocaleFormatting.formattedHeight(meters: 0.4)))
                    .foregroundStyle(.secondary)
            case let .failed(message):
                Text(message).foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(repository: PreviewPokemonRepository())
    )
}

private final class PreviewPokemonRepository: PokemonRepositoryProtocol {
    func pokemon(named name: String) async throws -> PokemonDetail {
        PokemonDetail(id: 25, name: name.uppercased())
    }
}
