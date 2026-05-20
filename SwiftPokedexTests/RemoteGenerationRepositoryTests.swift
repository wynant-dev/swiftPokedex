//
//  RemoteGenerationRepositoryTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class RemoteGenerationRepositoryTests: XCTestCase {
    func testFetchGenerationsMapsListAndEnrichesFromDetail() async throws {
        let client = MockAPIClient()
        client.fetchHandler = { url in
            if url.absoluteString.hasSuffix("/generation") {
                return PagedListDTO(
                    count: 1,
                    next: nil,
                    previous: nil,
                    results: [
                        NamedResourceDTO(
                            name: "generation-i",
                            url: "https://pokeapi.co/api/v2/generation/1/"
                        ),
                    ]
                )
            }

            if url.absoluteString.hasSuffix("/generation/1") {
                return GenerationDetailDTO(
                    id: 1,
                    name: "generation-i",
                    names: [
                        LocalizedNameDTO(
                            language: NamedResourceDTO(name: "en", url: "https://pokeapi.co/api/v2/language/9/"),
                            name: "Generation I"
                        ),
                    ]
                )
            }

            throw APIError.httpError(statusCode: 404)
        }

        let repository = RemoteGenerationRepository(client: client)
        let generations = try await repository.fetchGenerations()

        XCTAssertEqual(generations.count, 1)
        XCTAssertEqual(
            generations.first,
            Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: true)
        )
    }

    func testFetchGenerationsKeepsFallbackWhenDetailFails() async throws {
        let client = MockAPIClient()
        client.fetchHandler = { url in
            if url.absoluteString.hasSuffix("/generation") {
                return PagedListDTO(
                    count: 1,
                    next: nil,
                    previous: nil,
                    results: [
                        NamedResourceDTO(
                            name: "generation-i",
                            url: "https://pokeapi.co/api/v2/generation/1/"
                        ),
                    ]
                )
            }
            throw APIError.httpError(statusCode: 500)
        }

        let repository = RemoteGenerationRepository(client: client)
        let generations = try await repository.fetchGenerations()

        XCTAssertEqual(
            generations.first,
            Generation(id: 1, slug: "generation-i", displayName: "Generation I", isDisplayNameLocalized: false)
        )
    }

    func testFetchGenerationsPropagatesListAPIError() async {
        let client = MockAPIClient()
        client.result = .failure(APIError.httpError(statusCode: 500))
        let repository = RemoteGenerationRepository(client: client)

        do {
            _ = try await repository.fetchGenerations()
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpError(statusCode: 500))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
