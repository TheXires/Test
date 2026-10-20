import Foundation

public protocol ShoppingListStorage {
    func load() throws -> ShoppingList
    func save(_ list: ShoppingList) throws
}

/// Speichert die Liste als JSON-Datei.
public struct FileShoppingListStorage: ShoppingListStorage {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func load() throws -> ShoppingList {
        guard FileManager.default.fileExists(atPath: url.path) else { return ShoppingList() }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(ShoppingList.self, from: data)
    }

    public func save(_ list: ShoppingList) throws {
        let data = try JSONEncoder().encode(list)
        try data.write(to: url, options: .atomic)
    }
}

/// Hält die Liste nur im Speicher, z. B. für Tests und UI-Tests.
public final class InMemoryShoppingListStorage: ShoppingListStorage {
    public private(set) var list: ShoppingList

    public init(list: ShoppingList = ShoppingList()) {
        self.list = list
    }

    public func load() throws -> ShoppingList { list }

    public func save(_ list: ShoppingList) throws {
        self.list = list
    }
}
