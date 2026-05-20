//
//  GenerationDetailDTO.swift
//  SwiftPokedex
//

struct GenerationDetailDTO: Decodable {
    let id: Int
    let name: String
    let names: [LocalizedNameDTO]
}
