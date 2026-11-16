import Foundation

struct AddTodo {
    func perform(description: String, priority: Priority, to items: [TodoItem]) throws -> [TodoItem] {
        let title = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { throw TodoError.emptyDescription }
        guard !items.contains(where: { !$0.isCompleted && $0.description.localizedCaseInsensitiveCompare(title) == .orderedSame }) else {
            throw TodoError.duplicateItem
        }
        return Self.sorted(items + [TodoItem(description: title, priority: priority)])
    }

    static func sorted(_ items: [TodoItem]) -> [TodoItem] {
        items.sorted {
            if $0.isCompleted != $1.isCompleted { return !$0.isCompleted }
            if !$0.isCompleted && $0.priority != $1.priority { return $0.priority < $1.priority }
            return $0.createdAt < $1.createdAt
        }
    }
}

struct ToggleTodo {
    func perform(id: UUID, in items: [TodoItem]) -> [TodoItem] {
        var updated = items
        guard let index = updated.firstIndex(where: { $0.id == id }) else { return items }
        updated[index].toggleCompletion()
        return AddTodo.sorted(updated)
    }
}

struct DeleteTodo {
    func perform(id: UUID, from items: [TodoItem]) -> [TodoItem] { items.filter { $0.id != id } }
}
