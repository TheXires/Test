import XCTest
@testable import ShoppingListKit

final class ShoppingListTests: XCTestCase {
    func testAddTrimsWhitespace() {
        var list = ShoppingList()
        let item = list.add("  Milch \n")
        XCTAssertEqual(item?.name, "Milch")
        XCTAssertEqual(list.items.count, 1)
    }

    func testAddIgnoresEmptyNames() {
        var list = ShoppingList()
        XCTAssertNil(list.add(""))
        XCTAssertNil(list.add("   "))
        XCTAssertTrue(list.items.isEmpty)
    }

    func testAddingDuplicateIncreasesQuantity() {
        var list = ShoppingList()
        list.add("Eier")
        list.add("eier", quantity: 2)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list.items.first?.quantity, 3)
    }

    func testAddingDuplicateOfDoneItemCreatesNewItem() {
        var list = ShoppingList()
        let first = list.add("Brot")!
        list.toggle(id: first.id)
        list.add("Brot")
        XCTAssertEqual(list.items.count, 2)
        XCTAssertEqual(list.openItems.count, 1)
        XCTAssertEqual(list.doneItems.count, 1)
    }

    func testQuantityIsAtLeastOne() {
        var list = ShoppingList()
        let item = list.add("Butter", quantity: 0)!
        XCTAssertEqual(item.quantity, 1)
        list.setQuantity(-5, for: item.id)
        XCTAssertEqual(list.items.first?.quantity, 1)
        list.setQuantity(4, for: item.id)
        XCTAssertEqual(list.items.first?.quantity, 4)
    }

    func testToggleMovesItemBetweenOpenAndDone() {
        var list = ShoppingList()
        let item = list.add("Käse")!
        list.toggle(id: item.id)
        XCTAssertEqual(list.doneItems.map(\.id), [item.id])
        XCTAssertTrue(list.openItems.isEmpty)
        list.toggle(id: item.id)
        XCTAssertEqual(list.openItems.map(\.id), [item.id])
    }

    func testRemoveByIds() {
        var list = ShoppingList()
        let a = list.add("Äpfel")!
        let b = list.add("Bananen")!
        list.add("Kirschen")
        list.remove(ids: [a.id, b.id])
        XCTAssertEqual(list.items.map(\.name), ["Kirschen"])
    }

    func testRemoveCompleted() {
        var list = ShoppingList()
        let a = list.add("Salz")!
        list.add("Pfeffer")
        list.toggle(id: a.id)
        list.removeCompleted()
        XCTAssertEqual(list.items.map(\.name), ["Pfeffer"])
    }
}
