import Foundation
@testable import SudoKing

class OnePasswordSessionMangerSpy: OnePasswordSessionManager {
    
    var session: String?
    
    override func getStoredSessionToken() -> String? {
        return session
    }
    
    override func createSession(session: String) throws {
        self.session = session
    }
    
    func removeSession() {
        session = nil
    }
    
    func reset() {
        self.removeSession()
    }
    
}
