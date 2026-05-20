//
//  PagedListDTO.swift
//  SwiftPokedex
//

struct PagedListDTO<Item: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]
}
