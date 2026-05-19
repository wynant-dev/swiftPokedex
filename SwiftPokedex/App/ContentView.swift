//
//  ContentView.swift
//  SwiftPokedex
//
//  Created by Aurélien Wynant on 17.05.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("SwiftPokedex")
                .navigationTitle("Pokédex")
        }
    }
}

#Preview {
    ContentView()
}
