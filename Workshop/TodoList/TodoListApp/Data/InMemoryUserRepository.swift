//
//  InMemoryUserRepository.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 10/11/26.
//

import Foundation

public final class InMemoryUserRepository: UserRepository {
    private var users: [String: User] = [:]
    public init() {}
    public func add(_ user: User) { users[user.email.lowercased()] = user }
    public func findByEmail(_ email: String) -> User? { users[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] }
    public func allUsers() -> [User] { users.values.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending } }
    public func remove(email: String) { users[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = nil }
}
