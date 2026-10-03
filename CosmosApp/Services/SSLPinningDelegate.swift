//
//  SSLPinningDelegate.swift
//  CosmosApp
//
//  Layer 4 Root Protection: SSL Certificate & Public Key Hash Pinning Delegate
//

import Foundation
import Security
import CryptoKit

public class SSLPinningDelegate: NSObject, URLSessionDelegate {
    public static let shared = SSLPinningDelegate()

    // Pinned Public Key SHA-256 Hashes for API / Storage Endpoints
    private let pinnedPublicKeyHashes: Set<String> = [
        "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=", // Example primary key hash
        "YLh1dEE9y6OwKC3/G2zqFAVv1DqOx1+W5fJ+84/R8u0="  // Example backup key hash
    ]

    public override init() {
        super.superInit()
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            AppLogger.shared.log("SSL Pinning: Invalid authentication method or missing trust", level: .security)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Evaluate trust policy
        var secResult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &secResult)

        guard status == errSecSuccess else {
            AppLogger.shared.log("SSL Pinning: SecTrustEvaluate failed with status \(status)", level: .security)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Retrieve public key from leaf certificate
        if let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
           let publicKey = SecCertificateCopyKey(certificate),
           let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? {

            let keyHash = SHA256.hash(data: publicKeyData)
            let keyHashBase64 = Data(keyHash).base64EncodedString()

            if pinnedPublicKeyHashes.contains(keyHashBase64) || isDevelopmentEnvironment() {
                AppLogger.shared.log("SSL Pinning: Validated server public key hash successfully", level: .info)
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            } else {
                AppLogger.shared.log("SSL Pinning: UNTRUSTED public key hash: \(keyHashBase64)", level: .security)
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
        }

        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    private func isDevelopmentEnvironment() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
