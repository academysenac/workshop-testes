import Foundation
import CryptoKit

/// Salted, iterated SHA-256 password storage for this workshop example.
/// A production service should use a dedicated password KDF such as Argon2id, scrypt or PBKDF2.
public struct SaltedSHA256HashService: HashService {
    private let rounds = 10_000
    public init() {}

    public func hash(_ password: String) -> String {
        let salt = Data((0..<16).map { _ in UInt8.random(in: .min ... .max) })
        return "sha256i$\(rounds)$\(salt.base64EncodedString())$\(digest(password, salt: salt).base64EncodedString())"
    }

    public func check(_ password: String, against hashed: String) -> Bool {
        let fields = hashed.split(separator: "$", omittingEmptySubsequences: false)
        guard fields.count == 4, fields[0] == "sha256i", let rounds = Int(fields[1]), rounds == self.rounds,
              let salt = Data(base64Encoded: String(fields[2])), let expected = Data(base64Encoded: String(fields[3])) else { return false }
        return digest(password, salt: salt) == expected
    }

    private func digest(_ password: String, salt: Data) -> Data {
        var value = salt + Data(password.utf8)
        for _ in 0..<rounds { value = Data(SHA256.hash(data: value)) }
        return value
    }
}
