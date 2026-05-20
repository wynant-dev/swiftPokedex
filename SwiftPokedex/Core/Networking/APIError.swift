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

    func userMessage(decodingContext: String = "data") -> String {
        switch self {
        case .invalidURL:
            "Invalid request."
        case let .httpError(statusCode):
            "Server error (\(statusCode))."
        case .decodingFailed:
            "Could not read \(decodingContext)."
        case let .transport(message):
            message
        }
    }
}
