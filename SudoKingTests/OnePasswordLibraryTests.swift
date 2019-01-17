import XCTest
@testable import SudoKing

class OnePasswordLibraryTests: XCTestCase {
    var onePasswordConfig: OnePasswordConfig!
    var bashUtility: BashUtilitySpy!
    var sessionManager: OnePasswordSessionMangerSpy!
    var lib: PasswordLibrary!

    override func setUp() {
        bashUtility = BashUtilitySpy()
        onePasswordConfig = OnePasswordConfig(
            subdomain: "test-subdomain",
            email: "test-email@example.com",
            secretKey: "secret-key",
            pathToOPBinary: "/path/to/op/bin",
            sessionExpirationMinutes: 1.0
        )
        sessionManager = OnePasswordSessionMangerSpy(config: onePasswordConfig)
        lib = OnePasswordLibrary(
            config: OnePasswordConfigManager.shared,
            cli: OnePasswordCli(bashUtility: bashUtility),
            sessionManager: sessionManager
        )
    }

    override func tearDown() {
        bashUtility.reset()
        sessionManager.reset()
    }
    
    func testValidateMasterPasswordSuccess() throws {
        bashUtility.addResponseToReturn(
            response: BashUtility.BashCommandResponse(
                exitCode: 0,
                stdout: "mySessionId",
                stderr: ""
            )
        )
        XCTAssertNoThrow(try lib.validateMasterPassword(password: "12345678901234567890"))
        XCTAssertEqual(sessionManager.getStoredSessionToken(), Optional("mySessionId"))
    }
    
    func testValidateMasterPasswordTooShort() throws {
        bashUtility.addResponseToReturn(
            response: BashUtility.BashCommandResponse(
                exitCode: 0,
                stdout: "mySessionId",
                stderr: ""
            )
        )
        XCTAssertThrowsError(try lib.validateMasterPassword(password: "short")) { (error) -> Void in
            XCTAssert(error is OnePasswordError)
            XCTAssertEqual((error as! OnePasswordError).message, "Master Password must be greater than 10 Characters")
        }
        XCTAssertEqual(sessionManager.getStoredSessionToken(), nil)
    }
    
    func testValidateMasterPasswordFailure() throws {
        bashUtility.addResponseToReturn(
            response: BashUtility.BashCommandResponse(
                exitCode: 145,
                stdout: "",
                stderr: "[LOG] 2018/12/29 15:30:06 (ERROR) 401: Authentication required."
            )
        )
        XCTAssertThrowsError(try lib.validateMasterPassword(password: "notMyPassword")) { (error) -> Void in
            XCTAssert(error is OnePasswordError)
            XCTAssertEqual((error as! OnePasswordError).message, "Invalid Password")
        }
        XCTAssertEqual(sessionManager.getStoredSessionToken(), nil)
    }
    
    func testRetrievePasswordList() throws {
        bashUtility.addResponseToReturn(
            response: BashUtility.BashCommandResponse(
                exitCode: 0,
                stdout: ListItemsResponse.success,
                stderr: ""
            )
        )
        try sessionManager.createSession(session: "SessionKey")
        
        let passwordList = try lib.retrievePasswordList()
        XCTAssertEqual(passwordList.count, 2)
        XCTAssertEqual(passwordList[0],
            PasswordListItem(uuid: "123abc", name: "Example Login 1", tags: Optional<[String]>(["yellow","blue"]))
        )
        XCTAssertEqual(passwordList[1],
            PasswordListItem(uuid: "456def", name: "Example Login 2", tags: Optional<[String]>(["blue","green"]))
        )
    }

    func testRetrievePassword() throws {
        bashUtility.addResponseToReturn(
            response: BashUtility.BashCommandResponse(
                exitCode: 0,
                stdout: GetPasswordResponse.success,
                stderr: ""
            )
        )
        try sessionManager.createSession(session: "SessionKey")
        XCTAssertEqual(try lib.retrievePassword(uuid: "dummy"), "thisismypassword")
    }
    
    func testValidateActiveSessionFalse() {
        sessionManager.removeSession()
        XCTAssertEqual(lib.validSessionActive(), false)
    }
    
    func testValidateActiveSessionTrue() throws {
        try sessionManager.createSession(session: "SessionKey")
        XCTAssertEqual(lib.validSessionActive(), true)
    }
}
