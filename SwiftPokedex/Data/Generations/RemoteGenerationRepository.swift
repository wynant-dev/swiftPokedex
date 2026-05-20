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
        let summaries = try GenerationMapper.toDomainList(from: response.results)

        return await ResourceEnrichment.enrich(
            summaries: summaries,
            fetchDetail: { [client] summary in
                let detailURL = try GenerationEndpoints.generation(id: summary.id)
                let detail: GenerationDetailDTO = try await client.fetch(detailURL)
                return detail
            },
            merge: { summary, detail in
                GenerationMapper.enriched(from: detail, summary: summary)
            }
        )
    }
}
