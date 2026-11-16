import Foundation

protocol TodoRepository: Sendable {
    func load() async throws -> [TodoItem]
    func save(_ items: [TodoItem]) async throws
}

protocol RemoteTodoService: Sendable {
    func sync(_ items: [TodoItem]) async throws
}
