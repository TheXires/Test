import Foundation
import ShoppingListKit

@MainActor
final class ShoppingListViewModel: ObservableObject {
    @Published private(set) var list: ShoppingList
    @Published var newItemName = ""

    private let storage: ShoppingListStorage

    init(storage: ShoppingListStorage) {
        self.storage = storage
        self.list = (try? storage.load()) ?? ShoppingList()
    }

    var canAddNewItem: Bool {
        !newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func addNewItem() {
        guard list.add(newItemName) != nil else { return }
        newItemName = ""
        persist()
    }

    func toggle(_ item: ShoppingItem) {
        list.toggle(id: item.id)
        persist()
    }

    func delete(_ ids: [ShoppingItem.ID]) {
        list.remove(ids: ids)
        persist()
    }

    func clearCompleted() {
        list.removeCompleted()
        persist()
    }

    private func persist() {
        do {
            try storage.save(list)
        } catch {
            print("Einkaufsliste konnte nicht gespeichert werden: \(error)")
        }
    }
}
