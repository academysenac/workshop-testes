import SwiftUI

@main
struct TodoListAppApp: App {
    @StateObject private var model = TodoViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if model.currentUser == nil {
                    LoginView(model: model)
                } else {
                    TodoListView(model: model)
                }
            }
        }
    }
}
