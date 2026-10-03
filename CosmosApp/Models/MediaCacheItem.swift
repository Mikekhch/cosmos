//
//  MediaCacheItem.swift
//  CosmosApp
//
//  Production Model for Smart Cache Storage Management
//

import Foundation

public struct MediaCacheItem: Identifiable, Codable, Equatable {
    public let id: String
    public let filename: String
    public let localPath: String
    public let sizeInBytes: Int64
    public var lastAccessedDate: Date
    public var isUploadedToServer: Bool
    public var mediaType: MediaType

    public enum MediaType: String, Codable {
        case video
        case audio
        case avatar3DMesh
        case thumbnail
    }

    public init(
        id: String = UUID().uuidString,
        filename: String,
        localPath: String,
        sizeInBytes: Int64,
        lastAccessedDate: Date = Date(),
        isUploadedToServer: Bool = false,
        mediaType: MediaType = .video
    ) {
        self.id = id
        self.filename = filename
        self.localPath = localPath
        self.sizeInBytes = sizeInBytes
        self.lastAccessedDate = lastAccessedDate
        self.isUploadedToServer = isUploadedToServer
        self.mediaType = mediaType
    }
}
