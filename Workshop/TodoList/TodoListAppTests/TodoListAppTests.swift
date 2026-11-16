//
//  TodoListAppTests.swift
//  TodoListAppTests
//
//  Created by Leonardo Takuno on 09/11/26.
//


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
    
    @MainActor
    @Test func deletingTaskLeavesOtherItemsInPlace() throws {
        let first = try AddTodo().perform(description: "Primeira", priority: .high, to: []).first!
        let second = TodoItem(description: "Segunda", priority: .low)
        #expect(DeleteTodo().perform(id: first.id, from: [first, second]) == [second])
    }
}

struct TodoViewModelTests {
    
    @Test @MainActor
    func addsAndPersistsTask() throws {
        // 1. Arrange: Instancia as dependências em memória
        let userRepository = InMemoryUserRepository()
        let listRepository = InMemoryTodoListRepository()

        let viewModel = TodoViewModel(
            users: userRepository,
            lists: listRepository
        )
        
        // 2. Registra e autentica um usuário para que currentUser != nil
        viewModel.register(name: "Gabriel", email: "gabriel@test.com", password: "123")
        // 3. Act: Executa a adição de item (método síncrono)
        viewModel.add(description: "Ler", priority: .high)

        // 4. Assert: Verifica a ViewModel e o repositório persistence
        #expect(viewModel.items.map(\.description) == ["Ler"])

        let savedList = listRepository.findByEmail("gabriel@test.com")
        #expect(savedList?.tasks.map(\.description) == ["Ler"])
    }
    
}
