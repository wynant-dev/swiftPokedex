//
//  LoadState.swift
//  SwiftPokedex
//

enum LoadState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)

    var value: T? {
        if case let .loaded(value) = self {
            return value
        }
        return nil
    }

    var errorMessage: String? {
        if case let .failed(message) = self {
            return message
        }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
