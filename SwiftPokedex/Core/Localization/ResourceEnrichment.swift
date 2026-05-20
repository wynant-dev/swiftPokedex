//
//  ResourceEnrichment.swift
//  SwiftPokedex
//

import Foundation

/// Fetches detail for list summaries in parallel and merges localized fields.
/// On per-item failure, keeps the summary.
enum ResourceEnrichment {
    static func enrich<S, D>(
        summaries: [S],
        fetchDetail: @escaping (S) async throws -> D,
        merge: @escaping (S, D) -> S
    ) async -> [S] {
        guard !summaries.isEmpty else { return [] }

        return await withTaskGroup(of: (Int, S).self, returning: [S].self) { group in
            for (index, summary) in summaries.enumerated() {
                group.addTask {
                    do {
                        let detail = try await fetchDetail(summary)
                        return (index, merge(summary, detail))
                    } catch {
                        return (index, summary)
                    }
                }
            }

            var byIndex: [Int: S] = [:]
            for await (index, item) in group {
                byIndex[index] = item
            }

            return summaries.indices.map { byIndex[$0] ?? summaries[$0] }
        }
    }
}
