//
//  Logger.swift
//  CosmosApp
//
//  Structured Production Logging Utility
//

import Foundation

public enum LogLevel: String {
    case info = "INFO"
    case debug = "DEBUG"
    case warning = "WARNING"
    case security = "SECURITY"
    case error = "ERROR"
}

public class AppLogger {
    public static let shared = AppLogger()
    private let queue = DispatchQueue(label: "com.cosmos.logger", qos: .utility)

    private init() {}

    public func log(_ message: String, level: LogLevel = .info, file: String = #file, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)

        queue.async {
            print("[\(dateString)] [\(level.rawValue)] [\(filename):\(line)] - \(message)")
        }
    }
}
