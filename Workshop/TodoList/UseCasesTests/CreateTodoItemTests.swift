//
//  CreateTodoItemTests.swift
//  TodoList
//
//  Created by Leonardo Takuno on 10/11/26.
//

import Testing

@testable import TodoListApp



struct CreateTodoItemTests {
    
    // 1. O app deve permitir registrar uma nova tarefa na lista de tarefas do usuário.
    @Test func createItemInTodoList() throws {
        // Given: repositorio da lista de tarefas, com usuário cadastrado, e uma lista de tarefas com uma tarefa registrada
        // When: criar um novo item na lista de tarefas do usuário
        // Then: ao recuperar os dados, a descrição da tarefa foi registrada corretamente.
    }
    
    // 2. O app deve gerar exceção de 'usuário inválido!' ao tentar cadastrar uma tarefa  e associar a um usuário não cadastrado
    @Test func createItemInTodoListWithInvalidUser(){
        // Guiven: repositorio vazio, sem usuários cadastradoes e sem tarefas cadastradas
        // When: criar um item e inserir na lista de tarefas do usuário
        // Then: gerar a exceção de usuário inválido
    }
    
    // 3. O app deve gerar exceção com a mensagem: "Já existe uma tarefa com essa descrição." Para os itens duplicados
    @Test func createDuplicateItemInTodoList() throws {
        // Given: repositorio da lista de tarefas, com usuário cadastrado, e uma lista de tarefas com uma tarefa registrada
        // When: ao cadastrar o item duplicado
        // Then: gerar a exceção de tarefa duplicado
    }
}
