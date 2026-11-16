import Foundation

public struct TodoList: Codable {
    public let owner: User
    private var items: [TodoItem] = []

    public init(owner: User) { self.owner = owner }
    public var count: Int { items.count }
    public var tasks: [TodoItem] { items }

    public func item(at index: Int) throws -> TodoItem {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        return items[index]
    }

    public func find(description: String) -> TodoItem? {
        items.first { $0.description.localizedCaseInsensitiveCompare(description) == .orderedSame }
    }

    public mutating func add(_ item: TodoItem) throws {
        let description = item.description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !description.isEmpty else { throw TodoListError.emptyDescription }
        try ensureUniqueAmongOpenItems(description)
        var newItem = item
        newItem.changeDescription(to: description)
        items.append(newItem)
        sort()
    }

    public mutating func complete(at index: Int) throws {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        items[index].complete()
        sort()
    }

    public mutating func complete(description: String) throws {
        guard let index = index(of: description) else { throw TodoListError.itemNotFound }
        items[index].complete()
        sort()
    }

    public mutating func undo(at index: Int) throws {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        items[index].undo()
        sort()
    }

    public mutating func undo(description: String) throws {
        guard let index = index(of: description) else { throw TodoListError.itemNotFound }
        items[index].undo()
        sort()
    }

    public mutating func remove(at index: Int) throws {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        items.remove(at: index)
    }

    public mutating func remove(description: String) throws {
        guard let index = index(of: description) else { throw TodoListError.itemNotFound }
        items.remove(at: index)
    }

    public mutating func changePriority(at index: Int, to priority: Priority) throws {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        items[index].changePriority(to: priority)
        sort()
    }

    public mutating func changePriority(description: String, to priority: Priority) throws {
        guard let index = index(of: description) else { throw TodoListError.itemNotFound }
        items[index].changePriority(to: priority)
        sort()
    }

    public mutating func changeDescription(at index: Int, to newDescription: String) throws {
        guard items.indices.contains(index) else { throw TodoListError.itemNotFound }
        let clean = newDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { throw TodoListError.emptyDescription }
        try ensureUniqueAmongOpenItems(clean, excluding: index)
        items[index].changeDescription(to: clean)
        sort()
    }

    public mutating func complete(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { throw TodoListError.itemNotFound }
        items[index].complete(); sort()
    }
    public mutating func undo(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { throw TodoListError.itemNotFound }
        items[index].undo(); sort()
    }
    public mutating func remove(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { throw TodoListError.itemNotFound }
        items.remove(at: index)
    }
    public mutating func changePriority(id: UUID, to priority: Priority) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { throw TodoListError.itemNotFound }
        items[index].changePriority(to: priority); sort()
    }
    public mutating func changeDescription(id: UUID, to newDescription: String) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { throw TodoListError.itemNotFound }
        let clean = newDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { throw TodoListError.emptyDescription }
        try ensureUniqueAmongOpenItems(clean, excluding: index)
        items[index].changeDescription(to: clean); sort()
    }

    public mutating func changeDescription(from oldDescription: String, to newDescription: String) throws {
        guard let index = index(of: oldDescription) else { throw TodoListError.itemNotFound }
        try changeDescription(at: index, to: newDescription)
    }

    private func index(of description: String) -> Int? {
        items.firstIndex { $0.description.localizedCaseInsensitiveCompare(description) == .orderedSame }
    }

    private func ensureUniqueAmongOpenItems(_ description: String, excluding index: Int? = nil) throws {
        if items.indices.contains(where: { $0 != index && !items[$0].isCompleted && items[$0].description.localizedCaseInsensitiveCompare(description) == .orderedSame }) {
            throw TodoListError.duplicateItem
        }
    }

    private mutating func sort() {
        items.sort {
            if $0.isCompleted != $1.isCompleted { return !$0.isCompleted }
            if !$0.isCompleted && $0.priority != $1.priority { return $0.priority < $1.priority }
            return $0.createdAt < $1.createdAt
        }
    }
}
