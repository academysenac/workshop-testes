public struct CreateTodoItem {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }
    public func perform(userEmail: String, description: String, priority: Priority) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.add(TodoItem(description: description, priority: priority))
        lists.update(email: userEmail, with: list)
    }
}
