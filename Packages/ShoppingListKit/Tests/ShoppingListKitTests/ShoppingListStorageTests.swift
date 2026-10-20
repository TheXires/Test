import XCTest
@testable import ShoppingListKit

final class ShoppingListStorageTests: XCTestCase {
    private var fileURL: URL!

    override func setUp() {
        super.setUp()
        fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("shopping-list-\(UUID().uuidString).json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
        super.tearDown()
    }

    func testLoadWithoutFileReturnsEmptyList() throws {
        let storage = FileShoppingListStorage(url: fileURL)
        XCTAssertEqual(try storage.load(), ShoppingList())
    }

    func testSaveAndLoadRoundTrip() throws {
        var list = ShoppingList()
        let item = list.add("Tomaten", quantity: 3)!
        list.toggle(id: item.id)
        list.add("Gurke")

        let storage = FileShoppingListStorage(url: fileURL)
        try storage.save(list)
        XCTAssertEqual(try storage.load(), list)
    }
}
