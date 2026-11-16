import Foundation

public struct User: Codable, Equatable {
    public let name: String
    public let email: String
    /// Contains the encoded password hash, never the raw password.
    public let password: String

    public init(name: String, email: String, password: String) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.password = password
    }
}
