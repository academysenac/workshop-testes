import Foundation

public final class JSONUserRepository: UserRepository {
    private var users: [String: User]
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? Self.defaultURL(named: "users.json")
        if let data = try? Data(contentsOf: self.fileURL), let stored = try? JSONDecoder().decode([String: User].self, from: data) {
            users = stored
        } else { users = [:] }
    }

    public func add(_ user: User) {
        users[user.email.lowercased()] = user
        persist()
    }

    public func findByEmail(_ email: String) -> User? {
        users[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()]
    }

    public func allUsers() -> [User] { users.values.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending } }

    public func remove(email: String) {
        users[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = nil
        persist()
    }

    private func persist() {
        guard let data = try? encoder.encode(users) else { return }
        try? FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: fileURL, options: .atomic)
    }

    fileprivate static func defaultURL(named name: String) -> URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("TodoListApp", isDirectory: true)
            .appendingPathComponent(name)
    }
}

public final class JSONTodoListRepository: TodoListRepository {
    private var lists: [String: TodoList]
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? JSONUserRepository.defaultURL(named: "lists.json")
        if let data = try? Data(contentsOf: self.fileURL), let stored = try? JSONDecoder().decode([String: TodoList].self, from: data) {
            lists = stored
        } else { lists = [:] }
    }

    public func add(_ todoList: TodoList) {
        lists[todoList.owner.email.lowercased()] = todoList
        persist()
    }

    public func findByEmail(_ email: String) -> TodoList? {
        lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()]
    }

    public func update(email: String, with todoList: TodoList) {
        lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = todoList
        persist()
    }

    public func remove(email: String) {
        lists[email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = nil
        persist()
    }

    private func persist() {
        guard let data = try? encoder.encode(lists) else { return }
        try? FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: fileURL, options: .atomic)
    }
}
