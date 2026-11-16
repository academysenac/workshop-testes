import Foundation

actor JSONTodoRepository: TodoRepository {
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("TodoListApp", isDirectory: true)
            .appendingPathComponent("todos.json")
    }

    func load() async throws -> [TodoItem] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        return try decoder.decode([TodoItem].self, from: Data(contentsOf: fileURL))
    }

    func save(_ items: [TodoItem]) async throws {
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(items).write(to: fileURL, options: .atomic)
    }
}
