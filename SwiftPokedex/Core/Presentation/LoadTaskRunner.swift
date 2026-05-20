//
//  LoadTaskRunner.swift
//  SwiftPokedex
//

import Foundation

@MainActor
final class LoadTaskRunner {
    private var task: Task<Void, Never>?

    func run<T: Equatable>(
        decodingContext: String,
        getState: @escaping () -> LoadState<T>,
        setState: @escaping (LoadState<T>) -> Void,
        operation: @escaping () async throws -> T
    ) {
        task?.cancel()
        task = Task {
            let staleValue = getState().value
            if staleValue == nil {
                setState(.loading)
            }

            do {
                let value = try await operation()
                guard !Task.isCancelled else { return }
                setState(.loaded(value))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                if let staleValue {
                    setState(.loaded(staleValue))
                } else {
                    setState(.failed(UserFacingError.message(for: error, decodingContext: decodingContext)))
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
