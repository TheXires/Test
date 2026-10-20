import SwiftUI
import ShoppingListKit

@main
struct ShoppingListApp: App {
    @StateObject private var viewModel = ShoppingListViewModel(storage: ShoppingListApp.makeStorage())

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }

    /// UI-Tests starten mit `-ui-testing` und bekommen eine frische, nicht persistierte Liste.
    private static func makeStorage() -> ShoppingListStorage {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            return InMemoryShoppingListStorage()
        }
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return FileShoppingListStorage(url: documents.appendingPathComponent("shopping-list.json"))
    }
}
