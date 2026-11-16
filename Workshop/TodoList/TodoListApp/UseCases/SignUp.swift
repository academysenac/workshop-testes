//
//  SignUp.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//


import Foundation

public struct SignUp {
    private let users: UserRepository
    private let hashService: HashService
    public init(users: UserRepository, hashService: HashService) { self.users = users; self.hashService = hashService }
    public func perform(name: String, email: String, password: String) throws {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !cleanName.isEmpty, !cleanEmail.isEmpty else { throw TodoListError.invalidUser }
        guard users.findByEmail(cleanEmail) == nil else { throw TodoListError.duplicateUser }
        guard !password.isEmpty else { throw TodoListError.invalidPassword }
        users.add(User(name: cleanName, email: cleanEmail, password: hashService.hash(password)))
    }

    static func isValid(_ password: String) -> Bool {
        !password.isEmpty
    }
}
