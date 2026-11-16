import SwiftUI


@MainActor
struct RegistrationView: View {
    @ObservedObject var model: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordVisible = false

    private var passwordsMatch: Bool { password == confirmPassword }
    private var passwordIsValid: Bool { !password.isEmpty }
    
    @ViewBuilder
    private var passwordField: some View {
        if passwordVisible {
                TextField("Senha", text: $password)
                    .textContentType(.newPassword)
        } else {
                SecureField("Senha", text: $password)
                    .textContentType(.newPassword)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Seus dados") {
                    TextField("Nome", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                    TextField("E-mail", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section("Segurança") {
                    passwordField
    
                    Toggle("Mostrar senha", isOn: $passwordVisible)
    
                    SecureField("Confirmar senha", text: $confirmPassword)
                        .textContentType(.newPassword)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Escolha uma senha (senhas simples também são aceitas).")
                            .font(.subheadline)
                        if !confirmPassword.isEmpty && !passwordsMatch {
                            Text("As senhas não conferem.").font(.caption).foregroundStyle(.red)
                        }
                    }
                }
                Section {
                    Button("Cadastrar") {
                        model.register(name: name, email: email, password: password)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !passwordIsValid || !passwordsMatch)
                }
            }
            .navigationTitle("Criar conta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Voltar") { dismiss() } } }
            .onChange(of: model.currentUser?.email) { _, email in
                if email != nil { dismiss() }
            }
            .alert("Não foi possível cadastrar", isPresented: errorBinding) {
                Button("OK", role: .cancel) { model.errorMessage = nil }
            } message: { Text(model.errorMessage ?? "") }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(get: { model.errorMessage != nil }, set: { if !$0 { model.errorMessage = nil } })
    }
}
