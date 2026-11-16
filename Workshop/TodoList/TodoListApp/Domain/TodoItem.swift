import Foundation

public struct TodoItem: Identifiable, Codable, Equatable {
    public let id: UUID
    public var description: String
    public private(set) var isCompleted: Bool
    public var priority: Priority
    public let createdAt: Date

    public init(id: UUID = UUID(), description: String, priority: Priority, isCompleted: Bool = false, createdAt: Date = .now) {
        self.id = id
        self.description = description
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }

    public mutating func toggleCompletion() { isCompleted.toggle() }
    public mutating func complete() { isCompleted = true }
    public mutating func undo() { isCompleted = false }
    public mutating func changeDescription(to description: String) { self.description = description }
    public mutating func changePriority(to priority: Priority) { self.priority = priority }
}

enum TodoError: LocalizedError, Equatable {
    case emptyDescription
    case duplicateItem
    var errorDescription: String? {
        switch self {
        case .emptyDescription: "Escreva uma tarefa antes de salvar."
        case .duplicateItem: "Já existe uma tarefa com esse nome."
        }
    }
}
