import Foundation

/// Ein einzelner Eintrag auf der Einkaufsliste.
public struct ShoppingItem: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var quantity: Int
    public var isDone: Bool

    public init(id: UUID = UUID(), name: String, quantity: Int = 1, isDone: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = max(1, quantity)
        self.isDone = isDone
    }
}
