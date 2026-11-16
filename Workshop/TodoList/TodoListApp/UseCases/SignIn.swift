//
//  SignIn.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

import Foundation
public struct SignIn {
    private let users: UserRepository
    private let hashService: HashService
    public init(users: UserRepository, hashService: HashService) { self.users = users; self.hashService = hashService }
    public func perform(email: String, password: String) throws -> Bool {
        guard let user = users.findByEmail(email), hashService.check(password, against: user.password) else {
            throw TodoListError.invalidCredentials
        }
        return true
    }
}

public struct ChangePassword {
    private let users: UserRepository
    private let hashService: HashService
    public init(users: UserRepository, hashService: HashService) { self.users = users; self.hashService = hashService }
    public func perform(email: String, currentPassword: String, newPassword: String) throws {
        guard let user = users.findByEmail(email), hashService.check(currentPassword, against: user.password) else {
            throw TodoListError.invalidCredentials
        }
        guard !newPassword.isEmpty else { throw TodoListError.invalidPassword }
        users.add(User(name: user.name, email: user.email, password: hashService.hash(newPassword)))
    }
}
