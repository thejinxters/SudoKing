import Foundation

protocol PasswordLibrary {
    func validateMasterPassword(password: String) throws
    
    func retrievePasswordList() -> [PasswordListItem]
    
    func retrievePassword(uuid: String) -> String?
    
    func validSessionActive() -> Bool
}
