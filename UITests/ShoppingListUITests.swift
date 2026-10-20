import XCTest

final class ShoppingListUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    @MainActor
    func testAddCompleteAndClearItem() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        let field = app.textFields["newItemField"]
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText("Milch")
        app.buttons["addButton"].tap()

        let item = app.buttons["item-Milch"]
        XCTAssertTrue(item.waitForExistence(timeout: 5))
        XCTAssertEqual(item.value as? String, "offen")

        item.tap()
        let doneValue = NSPredicate(format: "value == %@", "erledigt")
        expectation(for: doneValue, evaluatedWith: item)
        waitForExpectations(timeout: 5)

        let clearButton = app.buttons["clearCompletedButton"]
        XCTAssertTrue(clearButton.waitForExistence(timeout: 5))
        clearButton.tap()
        XCTAssertTrue(item.waitForNonExistence(timeout: 5))
    }
}
