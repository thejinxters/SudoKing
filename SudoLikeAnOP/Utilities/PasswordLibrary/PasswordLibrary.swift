import Foundation

protocol PasswordLibrary {
    func validateMasterPassword(password: String) throws
    
    func retrievePasswordList() throws -> [PasswordListItem]
    
    func retrievePassword(uuid: String) throws -> String
    
    func validSessionActive() -> Bool
}
