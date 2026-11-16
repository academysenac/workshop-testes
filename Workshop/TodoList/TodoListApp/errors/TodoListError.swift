import Foundation

public enum TodoListError: LocalizedError, Equatable {
    case duplicateItem, invalidUser, duplicateTodoList, invalidCredentials
    case invalidPassword, duplicateUser, invalidUserOrNoTodoList
    case itemNotFound, emptyDescription

    public var errorDescription: String? {
        switch self {
        case .duplicateItem: return "Já existe uma tarefa com essa descrição."
        case .invalidUser: return "Usuário inválido ou sem lista associada."
        case .duplicateTodoList: return "Este usuário já possui uma lista."
        case .invalidCredentials: return "E-mail ou senha inválidos."
        case .invalidPassword: return "Informe uma senha."
        case .duplicateUser: return "Já existe um usuário cadastrado com este e-mail."
        case .invalidUserOrNoTodoList: return "Usuário inválido ou sem lista associada."
        case .itemNotFound: return "Tarefa não encontrada."
        case .emptyDescription: return "A descrição da tarefa não pode ficar vazia."
        }
    }
}
