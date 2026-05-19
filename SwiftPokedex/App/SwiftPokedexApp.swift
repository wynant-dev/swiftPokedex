//
//  SwiftPokedexApp.swift
//  SwiftPokedex
//

import SwiftUI

@main
struct SwiftPokedexApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            PokemonDetailView(viewModel: container.makePokemonDetailViewModel())
        }
    }
}
