//
//  AnomalyDetectionEngine.swift
//  CosmosApp
//
//  Layer 3 AI Surveillance: Client Anomaly Detection Engine
//

import Foundation

public class AnomalyDetectionEngine {
    public static let shared = AnomalyDetectionEngine()

    // Anomaly Detection Thresholds
    private let maxMessagesPer5Seconds = 10
    private let maxPayloadSizeBytes: Int64 = 100 * 1024 // 100 KB

    private var messageTimestamps: [Date] = []
    private var securityEventsHistory: [SecurityEvent] = []
    private let queue = DispatchQueue(label: "com.cosmos.anomalydetection", qos: .utility)

    public var onAnomalyDetected: ((SecurityEvent) -> Void)?

    private init() {}

    // MARK: - Anomaly Analyzers

    public func recordAndAnalyzeMessageSend(payloadSizeBytes: Int64) -> SecurityEvent? {
        let now = Date()
        var detectedEvent: SecurityEvent?

        queue.sync {
            // Check Payload Size Anomaly
            if payloadSizeBytes > maxPayloadSizeBytes {
                let event = SecurityEvent(
                    eventType: .payloadSizeAnomaly,
                    severity: .high,
                    timestamp: now,
                    details: "Excessive payload size detected: \(payloadSizeBytes) bytes (limit \(maxPayloadSizeBytes) bytes)"
                )
                detectedEvent = event
                securityEventsHistory.append(event)
                AppLogger.shared.log("ANOMALY: \(event.details)", level: .security)
            }

            // Check Burst Velocity Anomaly
            messageTimestamps.append(now)
            // Filter timestamps within last 5 seconds
            messageTimestamps = messageTimestamps.filter { now.timeIntervalSince($0) <= 5.0 }

            if messageTimestamps.count > maxMessagesPer5Seconds {
                let event = SecurityEvent(
                    eventType: .burstVelocityAnomaly,
                    severity: .medium,
                    timestamp: now,
                    details: "Burst messaging velocity threshold exceeded: \(messageTimestamps.count) messages in 5 seconds"
                )
                detectedEvent = event
                securityEventsHistory.append(event)
                AppLogger.shared.log("ANOMALY: \(event.details)", level: .security)
            }
        }

        if let event = detectedEvent {
            onAnomalyDetected?(event)
        }

        return detectedEvent
    }

    public func analyzeGeolocationJump(lastDistanceKm: Double, timeIntervalSeconds: TimeInterval) -> SecurityEvent? {
        // e.g. 500 km jump in under 60 seconds is physically impossible -> location spoofing
        guard timeIntervalSeconds > 0 else { return nil }
        let impliedSpeedKmH = (lastDistanceKm / timeIntervalSeconds) * 3600.0

        if impliedSpeedKmH > 1000.0 { // Faster than commercial aircraft
            let event = SecurityEvent(
                eventType: .geolocationJump,
                severity: .high,
                timestamp: Date(),
                details: "Impossible geolocation jump detected: \(Int(lastDistanceKm)) km in \(Int(timeIntervalSeconds))s (Implied speed: \(Int(impliedSpeedKmH)) km/h)"
            )

            queue.sync {
                securityEventsHistory.append(event)
            }
            AppLogger.shared.log("ANOMALY: \(event.details)", level: .security)
            onAnomalyDetected?(event)
            return event
        }

        return nil
    }

    public func getSecurityAuditHistory() -> [SecurityEvent] {
        return queue.sync { securityEventsHistory }
    }
}
