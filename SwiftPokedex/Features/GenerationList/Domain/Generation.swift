//
//  Generation.swift
//  SwiftPokedex
//

struct Generation: Equatable, Identifiable {
    let id: Int
    let slug: String
    let displayName: String
    let isDisplayNameLocalized: Bool
}
