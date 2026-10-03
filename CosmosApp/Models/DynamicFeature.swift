//
//  DynamicFeature.swift
//  CosmosApp
//
//  Production Model for Dynamic Feature Modules (On-Demand Loading)
//

import Foundation

public enum DynamicFeatureState: Equatable, Codable {
    case notDownloaded
    case downloading(progress: Double)
    case installed
    case error(message: String)
}

public struct DynamicFeature: Identifiable, Equatable, Codable {
    public let id: String
    public let moduleName: String
    public let displayName: String
    public let downloadSizeMB: Double
    public var state: DynamicFeatureState
    public var memoryUsageMB: Double
    public var isLoadedInMemory: Bool

    public init(
        id: String,
        moduleName: String,
        displayName: String,
        downloadSizeMB: Double,
        state: DynamicFeatureState = .notDownloaded,
        memoryUsageMB: Double = 0.0,
        isLoadedInMemory: Bool = false
    ) {
        self.id = id
        self.moduleName = moduleName
        self.displayName = displayName
        self.downloadSizeMB = downloadSizeMB
        self.state = state
        self.memoryUsageMB = memoryUsageMB
        self.isLoadedInMemory = isLoadedInMemory
    }
}
