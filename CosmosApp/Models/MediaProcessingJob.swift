//
//  MediaProcessingJob.swift
//  CosmosApp
//
//  Production Model for Server-Side FFmpeg / Cloud Function Media Jobs
//

import Foundation

public enum JobStatus: String, Codable {
    case queued = "QUEUED"
    case processing = "PROCESSING"
    case completed = "COMPLETED"
    case failed = "FAILED"
}

public struct MediaProcessingJob: Identifiable, Codable, Equatable {
    public let id: String
    public let sourceFileName: String
    public let originalSizeBytes: Int64
    public var processedSizeBytes: Int64?
    public var status: JobStatus
    public var outputUrl: String?
    public var compressionRatio: Double?
    public let createdAt: Date
    public var completedAt: Date?

    public init(
        id: String = UUID().uuidString,
        sourceFileName: String,
        originalSizeBytes: Int64,
        processedSizeBytes: Int64? = nil,
        status: JobStatus = .queued,
        outputUrl: String? = nil,
        compressionRatio: Double? = nil,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.sourceFileName = sourceFileName
        self.originalSizeBytes = originalSizeBytes
        self.processedSizeBytes = processedSizeBytes
        self.status = status
        self.outputUrl = outputUrl
        self.compressionRatio = compressionRatio
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}
