public struct GetTodoList {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }
    public func perform(userEmail: String) throws -> TodoList {
        guard let list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        return list
    }
    public func item(userEmail: String, at index: Int) throws -> TodoItem { try perform(userEmail: userEmail).item(at: index) }
    public func item(userEmail: String, description: String) throws -> TodoItem {
        guard let item = try perform(userEmail: userEmail).find(description: description) else { throw TodoListError.itemNotFound }
        return item
    }
    public func count(userEmail: String) throws -> Int { try perform(userEmail: userEmail).count }
    public func owner(userEmail: String) throws -> User { try perform(userEmail: userEmail).owner }
}
