//
//  UserFacingError.swift
//  SwiftPokedex
//

import Foundation

enum UserFacingError {
    static func message(for error: Error, decodingContext: String) -> String {
        if let apiError = error as? APIError {
            return apiError.userMessage(decodingContext: decodingContext)
        }
        return error.localizedDescription
    }
}
