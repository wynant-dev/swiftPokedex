//
//  RemoteGenerationRepositoryTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class RemoteGenerationRepositoryTests: XCTestCase {
    func testFetchGenerationsMapsDTOToDomain() async throws {
        let client = MockAPIClient()
        client.result = .success(
            PagedListDTO(
                count: 2,
                next: nil,
                previous: nil,
                results: [
                    NamedResourceDTO(
                        name: "generation-i",
                        url: "https://pokeapi.co/api/v2/generation/1/"
                    ),
                    NamedResourceDTO(
                        name: "generation-ii",
                        url: "https://pokeapi.co/api/v2/generation/2/"
                    ),
                ]
            )
        )
        let repository = RemoteGenerationRepository(client: client)

        let generations = try await repository.fetchGenerations()

        XCTAssertEqual(
            generations,
            [
                Generation(id: 1, name: "Generation I"),
                Generation(id: 2, name: "Generation II"),
            ]
        )
    }

    func testFetchGenerationsPropagatesAPIError() async {
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
