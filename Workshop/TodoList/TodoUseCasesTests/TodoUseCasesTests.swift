
import Testing
@testable import TodoListApp

struct TodoUseCasesTests {
    @Test func sortsOpenItemsByPriorityAndCompletedItemsLast() throws {
        var items: [TodoItem] = []
        let add = AddTodo()
        items = try add.perform(description: "Baixa", priority: .low, to: items)
        items = try add.perform(description: "Alta", priority: .high, to: items)
        items = try add.perform(description: "Média", priority: .medium, to: items)
        #expect(items.map(\.description) == ["Alta", "Média", "Baixa"])
        items = ToggleTodo().perform(id: try #require(items.first?.id), in: items)
        #expect(items.map(\.description) == ["Média", "Baixa", "Alta"])
    }

    @Test func rejectsDuplicateTasksWithoutCaseSensitivity() throws {
        let items = try AddTodo().perform(description: "Comprar leite", priority: .low, to: [])
        #expect(throws: TodoError.duplicateItem) {
            try AddTodo().perform(description: "comprar LEITE", priority: .high, to: items)
        }
    }

    @Test func rejectsAnEmptyTask() {
        #expect(throws: TodoError.emptyDescription) {
            try AddTodo().perform(description: "  \n", priority: .medium, to: [])
        }
    }

    @Test func deletingTaskLeavesOtherItemsInPlace() throws {
        let first = try AddTodo().perform(description: "Primeira", priority: .high, to: []).first!
        let second = TodoItem(description: "Segunda", priority: .low)
        #expect(DeleteTodo().perform(id: first.id, from: [first, second]) == [second])
    }
}

struct TodoViewModelTests {
    @Test @MainActor func addsAndPersistsTask() async {
        let repository = InMemoryTodoRepository()
        let model = TodoViewModel(repository: repository)
        await model.add(description: "Ler", priority: .high)
        #expect(model.items.map(\.description) == ["Ler"])
        #expect(await repository.savedItems.map(\.description) == ["Ler"])
    }
}

private actor InMemoryTodoRepository: TodoRepository {
    private(set) var savedItems: [TodoItem] = []
    func load() async throws -> [TodoItem] { savedItems }
    func save(_ items: [TodoItem]) async throws { savedItems = items }
}
