//
//  TodoItemTests.swift
//  TodoItemTests
//
//  Created by Leonardo Takuno on 10/11/26.
// https://developer.apple.com/documentation/testing


import Testing
@testable import TodoListApp

struct TodoItemTests {

    // 1. O app deve criar uma tarefa com descrição, status inicial não completo e prioridade.
    @Test func testTodoItemCreate()  {
        let item = TodoItem(description: "Aprender sobre testes", priority: Priority.low)
        #expect(item.description == "Aprender sobre testes")
        #expect(item.priority == .low)
        #expect(item.isCompleted == false)
    }
    
    // 2. O app deve permitir alterar a descrição da tarefa.
    @Test func testTodoItemChangeDescription()  {

    }

    // 3. O app deve permitir marcar a tarefa como completa.
    @Test func testTodoItemDone()  {

    }
    
    // 4. O app deve permitir marcar a tarefa como não completa.
    @Test func testTodoItemUndo()  {

    }
    
    // 5. O app deve permitir alterar a prioridade da tarefa para baixa, média ou alta.
    @Test(arguments: [Priority.low, Priority.medium, Priority.high])
    func changePriority(newPriority: Priority){

    }
}
