//
//  GetTodoListTests.swift
//  UseCasesTests
//
//  Created by Leonardo Takuno on 12/11/26.
//

import Foundation
import Testing

@testable import TodoListApp

struct GetTodoListTests {



    // 1. O app deve permitir recuperar uma lista de tarefas
    // de um usuário cadastrado.
    @Test func successfulTodoListRetrieval() throws {
        // Given: usuário cadastrado no repositório
        // When: criar a lista de tarefas do usuário
        // When: recuperar a lista de tarefas
        // Then: verificar se a lista foi recuperada corretamente
        
    }

    // 2. O app deve gerar erro ao tentar recuperar
    // uma lista de tarefas de um usuário inexistente.

    @Test func retrievalWithInvalidUser() throws {
        // Given: repositório sem listas cadastradas
        let invalidEmail = "invalid@user.com"

        // When / Then: tentar recuperar uma lista
        // de um usuário inexistente deve gerar erro
    }
}
