//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Leonardo Takuno on 10/11/26.
// https://developer.apple.com/documentation/testing


import Foundation
import Testing

@testable import TodoListApp

@MainActor
struct TodoListTests {

    private let owner = User (name: "Joe Doe", email: "joe@doe.com", password: "1234")

    // 1. Verificar a criação de uma lista e seu proprietário.
    @Test func oneTodoList() throws {
        var todoList = TodoList(owner: owner)

        let item = TodoItem(
            description: "make bed",
            priority: .low
        )
        try todoList.add(item)
        try #expect(todoList.item(at: 0) == item)
        #expect(todoList.owner == owner)
    }

    // 2. Verificar se um item pode ser concluído.
    @Test func completeItemFromTodoList() throws {

    }

    // 3. Remover um item da lista pelo índice.

    @Test func removeItemFromTodoList() throws {

    }

    // 4. Remover um item da lista pela descrição.

    @Test func removeItemByDescription() throws {

    }

    // 5. Pesquisar um item pela descrição.
    @Test func searchItemByDescription() throws {

    }

    // 6. Verificar se os itens são ordenados pela prioridade.
    @Test func itemsSortedByPriority() throws {

    }

    // 7. Alterar a prioridade de um item pelo índice.
    @Test func changePriorityByIndex() throws {

    }

    // 8. Alterar a prioridade de um item pela descrição.
    @Test func changePriorityByDescription() throws {

    }

    // 9. Impedir a inclusão de itens duplicados.
    @Test func shouldNotHaveDuplicatedItem() throws {

    }

    // 10. Alterar a descrição de um item.
    @Test func changeItemDescriptionFromTodoList() throws {

    }

    // 11. Impedir a alteração para uma descrição já existente.
    @Test func changeItemDescriptionFromTodoListDuplicate() throws {

    }

    // 12. Concluir um item pela descrição.
    @Test func completeItemByDescription() throws {

    }

    // 13. Verificar se a conclusão de um item
    // preserva sua posição na lista.
    @Test func completeItemByDescriptionAndPreservePosition() throws {

    }

    // 14. Verificar se a conclusão pelo índice
    // preserva a posição do item na lista.
    @Test func completeItemByIndexAndPreservePosition() throws {

    }
}

