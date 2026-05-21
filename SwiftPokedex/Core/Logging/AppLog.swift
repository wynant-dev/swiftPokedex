//
//  AppLog.swift
//  SwiftPokedex
//
//  Debug-only centralized logging. No injection — call sites stay simple.
//

import Foundation
import os

enum AppLog {
    private static let network = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "SwiftPokedex",
        category: "network"
    )

    static func network(_ message: String) {
        #if DEBUG
            network.info("\(message, privacy: .public)")
        #endif
    }
}
