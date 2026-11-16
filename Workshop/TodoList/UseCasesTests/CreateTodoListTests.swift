//
//  CreateTodoListTest.swift
//  UseCasesTests
//
//  Created by Leonardo Takuno on 11/11/26.
//

import Foundation

import Testing

@testable import TodoListApp



struct CreateTodoListTests {

    
    
    // 1. O app deve permitir cadastrar uma lista de tarefas do usuário com sucesso.
    @Test func createTodoListSucessful() throws {
        // Given: Usuario novo cadastrado repositório do usuário
        // When criar a lista de tarefas, associado ao usuário
        // Then: recuperar os dados da lista de repositório e verificar se foi persistido com sucesso
    }
    // 2. O app deve gerar exceção para as tentativas de cadastros de tarefas para usuários inválidos.
    @Test func creationWithInvalidUser() throws {
        // Guiven: repositorio vazio, sem usuários cadastradoes e sem tarefas cadastradas
        let userEmail = "invalid.user@email.com"
        // When: criar um item e inserir na lista de tarefas do usuário
        // Then: gerar a exceção de usuário inválido
    }
    
    // 3. O app deve impedir a criação de mais de uma lista de tarefas
    // para o mesmo usuário.
    @Test func duplicateTodoList() throws {
        // Given: usuário cadastrado no repositório
        // When: criar a primeira lista de tarefas
        // Then: tentar criar uma segunda lista deve gerar erro
    }
}
