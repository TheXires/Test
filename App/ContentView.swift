import SwiftUI
import ShoppingListKit

struct ContentView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Neuer Artikel", text: $viewModel.newItemName)
                            .focused($isInputFocused)
                            .submitLabel(.done)
                            .onSubmit { viewModel.addNewItem() }
                            .accessibilityIdentifier("newItemField")

                        Button {
                            viewModel.addNewItem()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!viewModel.canAddNewItem)
                        .accessibilityLabel("Hinzufügen")
                        .accessibilityIdentifier("addButton")
                    }
                }

                if viewModel.list.items.isEmpty {
                    Section {
                        Text("Deine Liste ist leer.")
                            .foregroundStyle(.secondary)
                    }
                }

                itemSection("Offen", items: viewModel.list.openItems)
                itemSection("Erledigt", items: viewModel.list.doneItems)
            }
            .navigationTitle("Einkaufsliste")
            .toolbar {
                if !viewModel.list.doneItems.isEmpty {
                    Button("Erledigte löschen", role: .destructive) { viewModel.clearCompleted() }
                        .accessibilityIdentifier("clearCompletedButton")
                }
            }
        }
    }

    @ViewBuilder
    private func itemSection(_ title: String, items: [ShoppingItem]) -> some View {
        if !items.isEmpty {
            Section(title) {
                ForEach(items) { item in
                    ItemRow(item: item) { viewModel.toggle(item) }
                }
                .onDelete { offsets in
                    viewModel.delete(offsets.map { items[$0].id })
                }
            }
        }
    }
}

private struct ItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isDone ? Color.green : Color.secondary)
                Text(item.name)
                    .strikethrough(item.isDone)
                    .foregroundStyle(item.isDone ? Color.secondary : Color.primary)
                Spacer()
                if item.quantity > 1 {
                    Text("×\(item.quantity)")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityIdentifier("item-\(item.name)")
        .accessibilityValue(item.isDone ? "erledigt" : "offen")
    }
}

#Preview {
    ContentView(viewModel: ShoppingListViewModel(storage: InMemoryShoppingListStorage(
        list: ShoppingList(items: [
            ShoppingItem(name: "Milch", quantity: 2),
            ShoppingItem(name: "Brot"),
            ShoppingItem(name: "Eier", isDone: true),
        ])
    )))
}
