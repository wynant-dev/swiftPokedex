//
//  GenerationMapper.swift
//  SwiftPokedex
//

import Foundation

enum GenerationMapper {
    static func toDomainSummary(_ dto: NamedResourceDTO) throws -> Generation {
        let id = try ResourceURLParser.id(from: dto.url)
        let slug = dto.name
        return Generation(
            id: id,
            slug: slug,
            displayName: SlugDisplayNameFormatter.humanized(slug),
            isDisplayNameLocalized: false
        )
    }

    static func toDomainList(from items: [NamedResourceDTO]) throws -> [Generation] {
        try items.map { try toDomainSummary($0) }
    }

    static func enriched(from detail: GenerationDetailDTO, summary: Generation) -> Generation {
        Generation(
            id: detail.id,
            slug: detail.name,
            displayName: LocalizedNameResolver.displayName(
                from: detail.names,
                fallback: summary.displayName
            ),
            isDisplayNameLocalized: true
        )
    }
}
