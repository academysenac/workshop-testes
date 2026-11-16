import Foundation

public struct CompleteTodoItem {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }
    public func perform(userEmail: String, description: String) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.complete(description: description)
        lists.update(email: userEmail, with: list)
    }
    public func perform(userEmail: String, at index: Int) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.complete(at: index)
        lists.update(email: userEmail, with: list)
    }
    public func perform(userEmail: String, id: UUID) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.complete(id: id); lists.update(email: userEmail, with: list)
    }
}
