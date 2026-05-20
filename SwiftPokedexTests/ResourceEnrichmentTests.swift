//
//  ResourceEnrichmentTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class ResourceEnrichmentTests: XCTestCase {
    func testEnrichMergesSuccessfulDetails() async {
        let summaries = [1, 2]
        let enriched = await ResourceEnrichment.enrich(
            summaries: summaries,
            fetchDetail: { $0 * 10 },
            merge: { summary, detail in summary + detail }
        )

        XCTAssertEqual(enriched, [11, 22])
    }

    func testEnrichKeepsSummaryOnDetailFailure() async {
        let summaries = ["a", "b"]
        let enriched = await ResourceEnrichment.enrich(
            summaries: summaries,
            fetchDetail: { summary in
                if summary == "a" { throw APIError.decodingFailed }
                return summary.uppercased()
            },
            merge: { summary, detail in summary + detail }
        )

        XCTAssertEqual(enriched, ["a", "bB"])
    }
}
