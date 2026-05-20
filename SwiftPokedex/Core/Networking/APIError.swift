//
//  APIError.swift
//  SwiftPokedex
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingFailed
    case transport(String)

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.decodingFailed, .decodingFailed):
            true
        case let (.httpError(lhsCode), .httpError(rhsCode)):
            lhsCode == rhsCode
        case let (.transport(lhsMessage), .transport(rhsMessage)):
            lhsMessage == rhsMessage
        default:
            false
        }
    }
}

extension APIError {
    init(transport error: Error) {
        self = .transport(error.localizedDescription)
    }

    func userMessage(decodingContext: String) -> String {
        switch self {
        case .invalidURL:
            L10n.Error.invalidRequest
        case let .httpError(statusCode):
            L10n.Error.http(statusCode: statusCode)
        case .decodingFailed:
            L10n.Error.decodingFailed(context: decodingContext)
        case let .transport(message):
            message
        }
    }
}
