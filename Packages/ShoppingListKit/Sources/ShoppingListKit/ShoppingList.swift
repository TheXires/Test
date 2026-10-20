import Foundation

/// Die Einkaufsliste als Werttyp. Enthält die gesamte Logik, unabhängig von UI und Speicherung.
public struct ShoppingList: Codable, Equatable, Sendable {
    public private(set) var items: [ShoppingItem]

    public init(items: [ShoppingItem] = []) {
        self.items = items
    }

    public var openItems: [ShoppingItem] { items.filter { !$0.isDone } }
    public var doneItems: [ShoppingItem] { items.filter(\.isDone) }

    /// Fügt einen Artikel hinzu. Leere Namen werden ignoriert; existiert bereits ein offener
    /// Artikel mit gleichem Namen (ohne Groß-/Kleinschreibung), wird dessen Menge erhöht.
    @discardableResult
    public mutating func add(_ rawName: String, quantity: Int = 1) -> ShoppingItem? {
        let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let quantity = max(1, quantity)

        if let index = items.firstIndex(where: {
            !$0.isDone && $0.name.compare(name, options: .caseInsensitive) == .orderedSame
        }) {
            items[index].quantity += quantity
            return items[index]
        }

        let item = ShoppingItem(name: name, quantity: quantity)
        items.append(item)
        return item
    }

    public mutating func toggle(id: ShoppingItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isDone.toggle()
    }

    public mutating func setQuantity(_ quantity: Int, for id: ShoppingItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].quantity = max(1, quantity)
    }

    public mutating func remove(ids: some Sequence<ShoppingItem.ID>) {
        let ids = Set(ids)
        items.removeAll { ids.contains($0.id) }
    }

    public mutating func removeCompleted() {
        items.removeAll(where: \.isDone)
    }
}
