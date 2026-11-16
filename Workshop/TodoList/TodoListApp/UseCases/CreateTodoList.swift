//
//  Untitled.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

public struct CreateTodoList {
    private let users: UserRepository
    private let lists: TodoListRepository
    public init(users: UserRepository, lists: TodoListRepository) { self.users = users; self.lists = lists }
    public func perform(userEmail: String) throws {
        guard let owner = users.findByEmail(userEmail) else { throw TodoListError.invalidUser }
        guard lists.findByEmail(userEmail) == nil else { throw TodoListError.duplicateTodoList }
        lists.add(TodoList(owner: owner))
    }
}
