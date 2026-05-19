//
//  RemotePokemonRepositoryTests.swift
//  SwiftPokedexTests
//

@testable import SwiftPokedex
import XCTest

final class RemotePokemonRepositoryTests: XCTestCase {
    func testPokemonMapsDTOToDomain() async throws {
        let client = MockAPIClient()
        client.result = .success(PokemonDTO(id: 25, name: "pikachu"))
        let repository = RemotePokemonRepository(client: client)

        let detail = try await repository.pokemon(named: "pikachu")

        XCTAssertEqual(detail, PokemonDetail(id: 25, name: "PIKACHU"))
    }

    func testPokemonPropagatesAPIError() async {
        let client = MockAPIClient()
        client.result = .failure(APIError.httpError(statusCode: 500))
        let repository = RemotePokemonRepository(client: client)

        do {
            _ = try await repository.pokemon(named: "pikachu")
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpError(statusCode: 500))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
