//
//  TodoListRepository.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

public protocol TodoListRepository {
    func add(_ todoList: TodoList)
    func findByEmail(_ email: String) -> TodoList?
    func update(email: String, with todoList: TodoList)
    func remove(email: String)
}
