//
//  HashService.swift
//  TodoListApp
//
//  Created by Leonardo Takuno on 09/11/26.
//

import Foundation

public protocol HashService {
    func hash(_ password: String) -> String
    func check(_ password: String, against hashed: String) -> Bool
}
