//
//  InMemoryTodoListRepository.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 10/11/26.
//

import Foundation

public final class InMemoryTodoListRepository: TodoListRepository {
    private var lists: [String: TodoList] = [:]
    public init() {}
    public func add(_ todoList: TodoList) { lists[todoList.owner.email.lowercased()] = todoList }
    public func findByEmail(_ email: String) -> TodoList? { lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] }
    public func update(email: String, with todoList: TodoList) { lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = todoList }
    public func remove(email: String) { lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = nil }
}
