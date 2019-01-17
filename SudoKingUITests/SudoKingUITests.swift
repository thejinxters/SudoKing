import XCTest

class SudoKingUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClickUnlockWithPasswordError() {
        XCTAssert((app.staticTexts["errorMessage"].value as! String).isEmpty)
        app.typeText("stuff")
        app.buttons["unlock"].click()
        XCTAssertEqual(
            app.staticTexts["errorMessage"].value as! String,
            "Master Password must be greater than 10 Characters"
        )
    }
}
