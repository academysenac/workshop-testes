import Foundation

public struct RemoveItem {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }
    public func perform(userEmail: String, description: String) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.remove(description: description)
        lists.update(email: userEmail, with: list)
    }
    public func perform(userEmail: String, at index: Int) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.remove(at: index)
        lists.update(email: userEmail, with: list)
    }
    public func perform(userEmail: String, id: UUID) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.remove(id: id); lists.update(email: userEmail, with: list)
    }
}
