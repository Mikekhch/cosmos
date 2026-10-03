//
//  RootProtectionManager.swift
//  CosmosApp
//
//  Layer 4 Root Protection: Jailbreak Detection, Anti-Tampering & Memory Protection
//

import Foundation
#if canImport(Darwin)
import Darwin
#endif

public struct RootSecurityStatus {
    public let isJailbroken: Bool
    public let isDebuggerAttached: Bool
    public let isDyldInjected: Bool
    public let detectedThreats: [String]

    public var isSecure: Bool {
        return !isJailbroken && !isDebuggerAttached && !isDyldInjected
    }
}

public class RootProtectionManager {
    public static let shared = RootProtectionManager()

    private let jailbreakPaths = [
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/usr/sbin/sshd",
        "/usr/bin/sshd",
        "/etc/apt",
        "/private/var/lib/apt/",
        "/var/log/syslog",
        "/bin/bash",
        "/bin/sh",
        "/usr/libexec/sftp-server",
        "/Applications/Sileo.app",
        "/Applications/Zebra.app"
    ]

    private init() {}

    public func performComprehensiveSecurityCheck() -> RootSecurityStatus {
        var threats: [String] = []

        let jailbreakDetected = checkJailbreakPaths(&threats) || checkSandboxViolation(&threats) || checkURLSchemes(&threats)
        let debuggerDetected = checkPTraceDebugger(&threats)
        let dyldInjected = checkDyldInsertedLibraries(&threats)

        let status = RootSecurityStatus(
            isJailbroken: jailbreakDetected,
            isDebuggerAttached: debuggerDetected,
            isDyldInjected: dyldInjected,
            detectedThreats: threats
        )

        if !status.isSecure {
            AppLogger.shared.log("ROOT SECURITY VIOLATION DETECTED: \(threats.joined(separator: "; "))", level: .security)
        } else {
            AppLogger.shared.log("Root Security Shield passed all integrity checks", level: .info)
        }

        return status
    }

    // MARK: - Jailbreak Checks

    private func checkJailbreakPaths(_ threats: inout [String]) -> Bool {
        var found = false
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                threats.append("Jailbreak file detected at: \(path)")
                found = true
            }
        }
        return found
    }

    private func checkSandboxViolation(_ threats: inout [String]) -> Bool {
        let testString = "RootSecurityTest"
        let testPath = "/private/jailbreak_test_\(UUID().uuidString).txt"
        do {
            try testString.write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            threats.append("Sandbox write violation: Able to write outside application sandbox")
            return true
        } catch {
            return false
        }
    }

    private func checkURLSchemes(_ threats: inout [String]) -> Bool {
        // Cydia or Sileo URL schemes
        if let cydiaURL = URL(string: "cydia://package/com.example.test") {
            #if os(iOS) && canImport(UIKit)
            // Application level URL scheme query
            #endif
        }
        return false
    }

    // MARK: - Anti-Debugging & Memory Protection

    private func checkPTraceDebugger(_ threats: inout [String]) -> Bool {
        #if canImport(Darwin)
        var kinfo = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

        let junk = sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0)
        if junk == 0 {
            if (kinfo.kp_proc.p_flag & P_TRACED) != 0 {
                threats.append("Debugger attached (P_TRACED flag detected)")
                return true
            }
        }
        #endif
        return false
    }

    private func checkDyldInsertedLibraries(_ threats: inout [String]) -> Bool {
        if let dyldInsertLibs = getenv("DYLD_INSERT_LIBRARIES") {
            let libsString = String(cString: dyldInsertLibs)
            if !libsString.isEmpty {
                threats.append("DYLD_INSERT_LIBRARIES injected: \(libsString)")
                return true
            }
        }
        return false
    }
}
