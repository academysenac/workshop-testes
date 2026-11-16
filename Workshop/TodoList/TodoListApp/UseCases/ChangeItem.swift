import Foundation

public enum ChangeType { case description, priority }

public struct ChangeItem {
    private let lists: TodoListRepository
    public init(lists: TodoListRepository) { self.lists = lists }

    public func perform(userEmail: String, description: String, change: ChangeType, newDescription: String? = nil, newPriority: Priority? = nil) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        switch change {
        case .description:
            guard let newDescription else { throw TodoListError.emptyDescription }
            try list.changeDescription(from: description, to: newDescription)
        case .priority:
            guard let newPriority else { throw TodoListError.itemNotFound }
            try list.changePriority(description: description, to: newPriority)
        }
        lists.update(email: userEmail, with: list)
    }

    public func changePriority(userEmail: String, at index: Int, to priority: Priority) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.changePriority(at: index, to: priority)
        lists.update(email: userEmail, with: list)
    }

    public func changeDescription(userEmail: String, at index: Int, to description: String) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        try list.changeDescription(at: index, to: description)
        lists.update(email: userEmail, with: list)
    }

    public func change(userEmail: String, id: UUID, description: String? = nil, priority: Priority? = nil) throws {
        guard var list = lists.findByEmail(userEmail) else { throw TodoListError.invalidUserOrNoTodoList }
        if let description { try list.changeDescription(id: id, to: description) }
        if let priority { try list.changePriority(id: id, to: priority) }
        lists.update(email: userEmail, with: list)
    }
}
