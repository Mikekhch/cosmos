//
//  SecurityEvent.swift
//  CosmosApp
//
//  Production Model for Security Alerts and Anomaly Audit Logs
//

import Foundation

public enum SecuritySeverity: String, Codable, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
}

public enum SecurityEventType: String, Codable, CaseIterable {
    case jailbreakDetected = "JAILBREAK_DETECTED"
    case sslPinningFailure = "SSL_PINNING_FAILURE"
    case memoryTamperDetected = "MEMORY_TAMPER_DETECTED"
    case debuggerAttached = "DEBUGGER_ATTACHED"
    case appCheckFailure = "APP_CHECK_FAILURE"
    case burstVelocityAnomaly = "BURST_VELOCITY_ANOMALY"
    case payloadSizeAnomaly = "PAYLOAD_SIZE_ANOMALY"
    case geolocationJump = "GEOLOCATION_JUMP"
}

public struct SecurityEvent: Identifiable, Codable, Equatable {
    public let id: String
    public let eventType: SecurityEventType
    public let severity: SecuritySeverity
    public let timestamp: Date
    public let details: String
    public let deviceId: String
    public var reportedToCloud: Bool

    public init(
        id: String = UUID().uuidString,
        eventType: SecurityEventType,
        severity: SecuritySeverity,
        timestamp: Date = Date(),
        details: String,
        deviceId: String = "DEV-SEC-" + String(Int.random(in: 1000...9999)),
        reportedToCloud: Bool = false
    ) {
        self.id = id
        self.eventType = eventType
        self.severity = severity
        self.timestamp = timestamp
        self.details = details
        self.deviceId = deviceId
        self.reportedToCloud = reportedToCloud
    }
}
