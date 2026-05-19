//
//  PokemonMapper.swift
//  SwiftPokedex
//

enum PokemonMapper {
    static func toDomain(_ dto: PokemonDTO) -> PokemonDetail {
        PokemonDetail(id: dto.id, name: dto.name.uppercased())
    }
}
