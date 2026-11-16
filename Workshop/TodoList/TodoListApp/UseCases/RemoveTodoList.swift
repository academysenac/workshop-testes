//
//  RemoveTodoList.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

public struct RemoveTodoList {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }
    public func perform(userEmail: String) throws {
        guard lists.findByEmail(userEmail) != nil else { throw TodoListError.invalidUserOrNoTodoList }
        lists.remove(email: userEmail)
    }
}
