//
//  CompleteTodoItem.swift
//  TodoList
//
//  Created by Leonardo Takuno on 10/11/26.
//

import Testing

@testable import TodoListApp


struct CompleteTodoItemTests {
    // 1. O app deve permitir completar a tarefa na lista de tarefas do usuário
    @Test("Completar a tarefa na lista de tarefas do usuário")
    func completeItemInTodoList() throws {
        // Given: repositorio da lista de tarefas, com usuário cadastrado, e uma lista de tarefas com uma tarefa registrada
        // When: completar a tarefa
        // Then: ao recuperar os dados, o status completo
    }
    
    // 2. O app deve gerar exceção de 'usuário inválido!' ao tentar completar uma tarefa de um usuário não cadastrado
    @Test("Gerar exceção de 'usuário inválido!' ao tentar completar uma tarefa de um usuário não cadastrado")
    func completeItemInvalidUser() throws {
        // Given: um repositorio sem usuários cadastrados
        // When: tentar completar uma tarefa
        // Then: gerar exception invalidUserOrNoTodoList
    }
}
