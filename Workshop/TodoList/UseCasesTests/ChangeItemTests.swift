//
//  ChangeItemTests.swift
//  UseCases
//
//  Created by Leonardo Takuno on 10/11/26.
//
// https://developer.apple.com/documentation/testing

import Testing

@testable import TodoListApp


struct ChangeItemTests {

    //  1. O app deve permitir alterar a descrição de uma tarefa já registrada na lista do usuário.
    @Test func changeItemDescription() throws {
        // Given: conta de usuario com lista de tarefas com uma tarefa persistida
        // When: alterar a descrição de uma tarefa e realizar a persistencia
        // Then: ao recuperar os dados, a descrição está alterada
    }

    //  2. O app deve informar um erro quando a descrição for alterada para um usuário inválido.
    @Test func changeItemDescriptionWithInvalidUser() throws {
        // Given: repositorio da lista de tarefas e email não cadastrado
        // When: tentar alterar a descrição
        // Then: gera a exception: invalidUserOrNoTodoList
    }

    //  3. O app deve permitir alterar a prioridade de uma tarefa já registrada na lista do usuário.
    @Test func changeItemPriority() throws {
        // Given: conta de usuario com lista de tarefas com uma tarefa persistida
        // When: alterar a prioridade de uma tarefa e realizar a persistencia
        // Then: ao recuperar os dados, a descrição está alterada
    }

    //  4. O app deve informar um erro quando a prioridade for alterada para um usuário inválido.
    @Test func changeItemPriorityWithInvalidUser() throws {
        // Given: repositorio da lista de tarefas e email não cadastrado
        // When: tentar alterar a prioridade
        // Then: gera a exception: invalidUserOrNoTodoList
    }
}
