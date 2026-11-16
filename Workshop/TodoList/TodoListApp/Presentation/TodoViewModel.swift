import Foundation
import Combine

@MainActor
final class TodoViewModel: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published private(set) var items: [TodoItem] = []
    @Published private(set) var registeredUsers: [User] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let users: any UserRepository
    private let lists: any TodoListRepository
    private let signUp: SignUp
    private let signIn: SignIn
    private let createList: CreateTodoList
    private let getList: GetTodoList
    private let createItem: CreateTodoItem
    private let completeItem: CompleteTodoItem
    private let undoItem: UndoTodoItem
    private let removeItem: RemoveItem
    private let changeItem: ChangeItem
    private let changePassword: ChangePassword

    init(users: (any UserRepository)? = nil, lists: (any TodoListRepository)? = nil, hashService: (any HashService)? = nil) {
        let userRepository = users ?? JSONUserRepository()
        let listRepository = lists ?? JSONTodoListRepository()
        let passwordHasher = hashService ?? SaltedSHA256HashService()
        self.users = userRepository
        self.lists = listRepository
        self.signUp = SignUp(users: userRepository, hashService: passwordHasher)
        self.signIn = SignIn(users: userRepository, hashService: passwordHasher)
        self.createList = CreateTodoList(users: userRepository, lists: listRepository)
        self.getList = GetTodoList(lists: listRepository)
        self.createItem = CreateTodoItem(lists: listRepository)
        self.completeItem = CompleteTodoItem(lists: listRepository)
        self.undoItem = UndoTodoItem(lists: listRepository)
        self.removeItem = RemoveItem(lists: listRepository)
        self.changeItem = ChangeItem(lists: listRepository)
        self.changePassword = ChangePassword(users: userRepository, hashService: passwordHasher)
        self.registeredUsers = userRepository.allUsers()
    }

    func updatePassword(current: String, new: String, confirmation: String) {
        guard new == confirmation else { errorMessage = "As senhas não conferem."; return }
        guard let email = currentUser?.email else { errorMessage = TodoListError.invalidCredentials.localizedDescription; return }
        do { try changePassword.perform(email: email, currentPassword: current, newPassword: new) }
        catch { errorMessage = error.localizedDescription }
    }

    func deleteAccount() {
        guard let email = currentUser?.email else { return }
        removeUser(email: email)
    }

    func removeUser(email: String) {
        lists.remove(email: email)
        users.remove(email: email)
        registeredUsers = users.allUsers()
        if currentUser?.email == email { logout() }
    }

    var openCount: Int { items.filter { !$0.isCompleted }.count }
    var totalCount: Int {
        guard let email = currentUser?.email else { return 0 }
        return (try? getList.count(userEmail: email)) ?? 0
    }
    var listOwner: User? {
        guard let email = currentUser?.email else { return nil }
        return try? getList.owner(userEmail: email)
    }

    func register(name: String, email: String, password: String) {
        do {
            try signUp.perform(name: name, email: email, password: password)
            let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            try createList.perform(userEmail: normalizedEmail)
            registeredUsers = users.allUsers()
            currentUser = users.findByEmail(normalizedEmail)
            refreshItems()
        } catch { errorMessage = error.localizedDescription }
    }

    func login(email: String, password: String) {
        do {
            _ = try signIn.perform(email: email, password: password)
            let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard let user = users.findByEmail(normalizedEmail) else { throw TodoListError.invalidCredentials }
            if lists.findByEmail(normalizedEmail) == nil { try createList.perform(userEmail: normalizedEmail) }
            currentUser = user
            refreshItems()
        } catch { errorMessage = error.localizedDescription }
    }

    func logout() { currentUser = nil; items = [] }

    func add(description: String, priority: Priority) {
        guard let email = currentUser?.email else { errorMessage = TodoListError.invalidUserOrNoTodoList.localizedDescription; return }
        do { try createItem.perform(userEmail: email, description: description, priority: priority); refreshItems() }
        catch { errorMessage = error.localizedDescription }
    }

    func toggle(_ item: TodoItem) {
        guard let email = currentUser?.email else { errorMessage = TodoListError.invalidUserOrNoTodoList.localizedDescription; return }
        do {
            if item.isCompleted { try undoItem.perform(userEmail: email, id: item.id) }
            else { try completeItem.perform(userEmail: email, id: item.id) }
            refreshItems()
        } catch { errorMessage = error.localizedDescription }
    }

    func delete(_ item: TodoItem) {
        guard let email = currentUser?.email else { errorMessage = TodoListError.invalidUserOrNoTodoList.localizedDescription; return }
        do { try removeItem.perform(userEmail: email, id: item.id); refreshItems() }
        catch { errorMessage = error.localizedDescription }
    }

    func update(_ item: TodoItem, description: String, priority: Priority) {
        guard let email = currentUser?.email else { errorMessage = TodoListError.invalidUserOrNoTodoList.localizedDescription; return }
        do {
            try changeItem.change(userEmail: email, id: item.id,
                                  description: item.description != description ? description : nil,
                                  priority: item.priority != priority ? priority : nil)
            refreshItems()
        } catch { errorMessage = error.localizedDescription }
    }

    func item(at index: Int) -> TodoItem? {
        guard let email = currentUser?.email else { return nil }
        return try? getList.item(userEmail: email, at: index)
    }

    func inspect(_ item: TodoItem) -> TodoItem {
        items.first(where: { $0.id == item.id }) ?? item
    }

    private func refreshItems() {
        guard let email = currentUser?.email else { items = []; return }
        do { items = try getList.perform(userEmail: email).tasks }
        catch { errorMessage = error.localizedDescription; items = [] }
    }
}
