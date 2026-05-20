//
//  LocalizedNameDTO.swift
//  SwiftPokedex
//

struct LocalizedNameDTO: Decodable, Equatable {
    let language: NamedResourceDTO
    let name: String
}
