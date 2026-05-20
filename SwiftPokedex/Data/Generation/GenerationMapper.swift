//
//  GenerationMapper.swift
//  SwiftPokedex
//

import Foundation

enum GenerationMapper {
    static func toDomain(_ dto: NamedResourceDTO) throws -> Generation {
        let id = try extractId(from: dto.url)
        return Generation(id: id, name: formatDisplayName(dto.name))
    }

    static func toDomainList(_ items: [NamedResourceDTO]) throws -> [Generation] {
        try items.map { try toDomain($0) }
    }

    private static func extractId(from urlString: String) throws -> Int {
        guard let url = URL(string: urlString),
              let idString = url.pathComponents.last(where: { !$0.isEmpty }),
              let id = Int(idString)
        else {
            throw APIError.decodingFailed
        }
        return id
    }

    private static func formatDisplayName(_ slug: String) -> String {
        let suffix = slug.replacingOccurrences(of: "generation-", with: "")
        return "Generation \(suffix.uppercased())"
    }
}
