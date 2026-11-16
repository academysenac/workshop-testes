//
//  RemoveItemTest.swift
//  UseCasesTests
//
//  Created by Leonardo Takuno on 12/11/26.
//


import Foundation
import Testing

@testable import TodoListApp

struct RemoveItemTests {

    private let userRepo = InMemoryUserRepository()
    private let todoListRepo = InMemoryTodoListRepository()
    private let hashService = FakeHashService()

    private let userName = "Joe Doe"
    private let userEmail = "joe@doe.com"
    private let userPassword = "test1234TEST&"

    private let itemDescription = "call mom"
    private let itemPriority = Priority.low

    // 1. O app deve permitir remover um item da lista de tarefas.
    @Test func removeItem() throws {

        // Given: usuário cadastrado e lista de tarefas criada
        try SignUp(users: userRepo, hashService: hashService)
            .perform(
                name: userName,
                email: userEmail,
                password: userPassword
            )

        try CreateTodoList(
            users: userRepo,
            lists: todoListRepo
        ).perform(userEmail: userEmail)

        // When: adicionar um item à lista
        try CreateTodoItem(lists: todoListRepo)
            .perform(
                userEmail: userEmail,
                description: itemDescription,
                priority: itemPriority
            )

        // When: remover o item da lista
        let useCase = RemoveItem(lists: todoListRepo)

        try useCase.perform(
            userEmail: userEmail,
            description: itemDescription
        )

        // Then: verificar se o item foi removido
        let persistedTodoList = todoListRepo.findByEmail(userEmail)

        #expect(persistedTodoList?.count == 0)
    }

    // 2. O app deve gerar erro ao tentar remover
    // um item de um usuário inexistente.
    @Test func removeItemInvalidUser() throws {

    }
}
