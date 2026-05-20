//
//  RemoteGenerationRepository.swift
//  SwiftPokedex
//

final class RemoteGenerationRepository: GenerationListRepositoryProtocol {
    private let client: any APIClientProtocol

    init(client: any APIClientProtocol) {
        self.client = client
    }

    func fetchGenerations() async throws -> [Generation] {
        let url = try GenerationEndpoints.generations()
        let response: PagedListDTO<NamedResourceDTO> = try await client.fetch(url)
        return try GenerationMapper.toDomainList(response.results)
    }
}
