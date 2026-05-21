//
//  GenerationDetailDTO.swift
//  SwiftPokedex
//

struct GenerationDetailDTO: Decodable {
    let id: Int
    let name: String
    let names: [LocalizedNameDTO]
    let pokemon_species: [NamedResourceDTO]
}
