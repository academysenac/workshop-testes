//
//  File.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

import Foundation

public protocol UserRepository {
    func add(_ user: User)
    func findByEmail(_ email: String) -> User?
    func allUsers() -> [User]
    func remove(email: String)
}
