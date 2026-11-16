//
//  FakeHashService.swift
//  TodoList
//
//  Created by Leonardo Takuno on 10/11/26.
//

import TodoListApp

public final class FakeHashService: HashService {
    public init() {}
    
    public func hash(_ password: String) -> String {
        return "\(password)HASHED"
    }
    public func check(_ password: String, against hashed: String) -> Bool {
        if hashed == "\(password)HASHED" {
            return true
        }
        return false
    }
}
