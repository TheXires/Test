import XCTest
import ShoppingListKit
@testable import ShoppingList

@MainActor
final class ShoppingListViewModelTests: XCTestCase {
    func testAddNewItemClearsInputAndPersists() {
        let storage = InMemoryShoppingListStorage()
        let viewModel = ShoppingListViewModel(storage: storage)

        viewModel.newItemName = "Milch"
        XCTAssertTrue(viewModel.canAddNewItem)
        viewModel.addNewItem()

        XCTAssertEqual(viewModel.newItemName, "")
        XCTAssertEqual(viewModel.list.items.map(\.name), ["Milch"])
        XCTAssertEqual(storage.list, viewModel.list)
    }

    func testBlankInputIsNotAdded() {
        let viewModel = ShoppingListViewModel(storage: InMemoryShoppingListStorage())
        viewModel.newItemName = "   "
        XCTAssertFalse(viewModel.canAddNewItem)
        viewModel.addNewItem()
        XCTAssertTrue(viewModel.list.items.isEmpty)
        XCTAssertEqual(viewModel.newItemName, "   ")
    }

    func testLoadsExistingList() {
        let storage = InMemoryShoppingListStorage(list: ShoppingList(items: [ShoppingItem(name: "Brot")]))
        let viewModel = ShoppingListViewModel(storage: storage)
        XCTAssertEqual(viewModel.list.items.map(\.name), ["Brot"])
    }

    func testToggleDeleteAndClearCompleted() {
        let storage = InMemoryShoppingListStorage()
        let viewModel = ShoppingListViewModel(storage: storage)
        for name in ["Äpfel", "Bananen", "Kirschen"] {
            viewModel.newItemName = name
            viewModel.addNewItem()
        }

        let apples = viewModel.list.items[0]
        viewModel.toggle(apples)
        XCTAssertEqual(viewModel.list.doneItems.map(\.name), ["Äpfel"])

        viewModel.delete([viewModel.list.items[1].id])
        XCTAssertEqual(viewModel.list.items.map(\.name), ["Äpfel", "Kirschen"])

        viewModel.clearCompleted()
        XCTAssertEqual(viewModel.list.items.map(\.name), ["Kirschen"])
        XCTAssertEqual(storage.list, viewModel.list)
    }
}
