import SwiftUI

@MainActor
struct TodoListView: View {
    @ObservedObject var model: TodoViewModel
    @State private var showingNewTodo = false
    @State private var selectedItem: TodoItem?
    @State private var searchText = ""
    @State private var showingUsers = false
    @State private var showingPassword = false
    @State private var confirmingDeleteAccount = false

    private var visibleItems: [TodoItem] {
        guard !searchText.isEmpty else { return model.items }
        return model.items.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.items.isEmpty {
                    ContentUnavailableView {
                        Label("Tudo em dia", systemImage: "checkmark.circle")
                    } description: {
                        Text("Adicione uma tarefa para começar sua lista.")
                    } actions: {
                        Button("Nova tarefa", systemImage: "plus") { showingNewTodo = true }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        Section {
                            ForEach(visibleItems) { item in
                                TodoRow(item: item) { model.toggle(item) }
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedItem = model.inspect(item) }
                                    .swipeActions(edge: .leading) {
                                        Button(item.isCompleted ? "Reabrir" : "Concluir", systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark") { model.toggle(item) }
                                            .tint(item.isCompleted ? .orange : .green)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button("Apagar", systemImage: "trash", role: .destructive) { model.delete(item) }
                                    }
                                    .accessibilityValue("Posição \(model.items.firstIndex(where: { $0.id == item.id }).map { $0 + 1 } ?? 0)")
                            }
                        } header: {
                            Text("\(model.openCount) pendentes · \(model.totalCount) no total")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Buscar por descrição")
                }
            }
            .navigationTitle("Minhas tarefas")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Text(model.listOwner?.name ?? "Usuário")
                        Text(model.listOwner?.email ?? "")
                        Button("Usuários cadastrados", systemImage: "person.2") { showingUsers = true }
                        Button("Alterar senha", systemImage: "key") { showingPassword = true }
                        Button("Remover minha conta", systemImage: "person.crop.circle.badge.xmark", role: .destructive) { confirmingDeleteAccount = true }
                        Button("Sair", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) { model.logout() }
                    } label: { Label("Conta", systemImage: "person.crop.circle") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Nova tarefa", systemImage: "plus") { showingNewTodo = true }
                }
            }
            .sheet(isPresented: $showingNewTodo) {
                TaskEditorView(title: "Nova tarefa") { description, priority in model.add(description: description, priority: priority) }
            }
            .sheet(item: $selectedItem) { item in
                TaskEditorView(title: "Editar tarefa", item: item) { description, priority in model.update(item, description: description, priority: priority) }
            }
            .sheet(isPresented: $showingUsers) { RegisteredUsersView(model: model) }
            .sheet(isPresented: $showingPassword) { ChangePasswordView(model: model) }
            .confirmationDialog("Remover sua conta?", isPresented: $confirmingDeleteAccount, titleVisibility: .visible) {
                Button("Remover conta e tarefas", role: .destructive) { model.deleteAccount() }
                Button("Cancelar", role: .cancel) { }
            } message: { Text("Sua conta e todas as tarefas associadas serão apagadas.") }
            .alert("Não foi possível concluir", isPresented: Binding(
                get: { model.errorMessage != nil },
                set: { if !$0 { model.errorMessage = nil } }
            )) { Button("OK", role: .cancel) { model.errorMessage = nil } } message: {
                Text(model.errorMessage ?? "")
            }
        }
    }
}

private struct RegisteredUsersView: View {
    @ObservedObject var model: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.registeredUsers, id: \.email) { user in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                        Text(user.email).font(.caption).foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button("Remover", systemImage: "trash", role: .destructive) {
                            let removesCurrentUser = model.currentUser?.email == user.email
                            model.removeUser(email: user.email)
                            if removesCurrentUser { dismiss() }
                        }
                    }
                }
            }
            .navigationTitle("Usuários cadastrados")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Concluir") { dismiss() } } }
        }
    }
}

private struct ChangePasswordView: View {
    @ObservedObject var model: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var current = ""
    @State private var new = ""
    @State private var confirmation = ""
    @State private var showError = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Senha atual") { SecureField("Senha atual", text: $current) }
                Section("Nova senha") {
                    SecureField("Nova senha", text: $new)
                    SecureField("Confirmar nova senha", text: $confirmation)
                    Text("Senhas simples também são aceitas.").font(.caption).foregroundStyle(.secondary)
                }
                Section {
                    Button("Salvar nova senha") {
                        model.errorMessage = nil
                        model.updatePassword(current: current, new: new, confirmation: confirmation)
                        if model.errorMessage == nil { dismiss() } else { showError = true }
                    }
                    .disabled(current.isEmpty || new.isEmpty || confirmation.isEmpty)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Alterar senha")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .alert("Não foi possível alterar a senha", isPresented: $showError) {
                Button("OK", role: .cancel) { model.errorMessage = nil }
            } message: { Text(model.errorMessage ?? "") }
        }
    }
}

private struct TodoRow: View {
    let item: TodoItem
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.description)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .strikethrough(item.isCompleted)
                if !item.isCompleted {
                    Text(item.priority.title.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(priorityColor)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.weight(.semibold)).foregroundStyle(.tertiary)
        }
        .padding(.vertical, 3)
        .accessibilityHint("Toque para editar a tarefa. Use o círculo para alterar o status.")
    }

    private var priorityColor: Color {
        switch item.priority {
        case .high: .red
        case .medium: .orange
        case .low: .secondary
        }
    }
}

private struct TaskEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var description: String
    @State private var priority: Priority
    let title: String
    let onSave: (String, Priority) -> Void

    init(title: String, item: TodoItem? = nil, onSave: @escaping (String, Priority) -> Void) {
        self.title = title
        self.onSave = onSave
        _description = State(initialValue: item?.description ?? "")
        _priority = State(initialValue: item?.priority ?? .medium)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Descrição") {
                    TextField("O que você precisa fazer?", text: $description, axis: .vertical)
                        .lineLimit(1...5)
                }
                Section("Prioridade") {
                    Picker("Prioridade", selection: $priority) {
                        ForEach(Priority.allCases) { value in Text(value.title).tag(value) }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { onSave(description, priority); dismiss() }
                        .disabled(description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
