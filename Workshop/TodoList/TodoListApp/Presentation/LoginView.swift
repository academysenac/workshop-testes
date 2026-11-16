//
//  LoginView.swift
//  TodoList
//
//  Created by Leonardo Takuno on 10/11/26.
//
import SwiftUI

@MainActor
struct LoginView: View {
    @ObservedObject var model: TodoViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegistration = false

    private var errorBinding: Binding<Bool> {
        Binding(get: { model.errorMessage != nil }, set: { if !$0 { model.errorMessage = nil } })
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("E-mail", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("Senha", text: $password)
                        .textContentType(.password)
                }
                Section {
                    Button("Entrar") { model.login(email: email, password: password) }
                        .frame(maxWidth: .infinity)
                        .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)
                }
                Section {
                    Button("Criar uma conta") { showingRegistration = true }
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Entrar")
            .sheet(isPresented: $showingRegistration) { RegistrationView(model: model) }
            .alert("Não foi possível entrar", isPresented: errorBinding) {
                Button("OK", role: .cancel) { model.errorMessage = nil }
            } message: { Text(model.errorMessage ?? "") }
        }
    }
}
