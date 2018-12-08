import Foundation

protocol PasswordLibrary {
    func validateMasterPassword(password: String) -> Bool
    
    func retrievePasswordList() -> [PasswordListItem]
    
    func retrievePassword(uuid: String) -> String?
    
    func validSessionActive() -> Bool
}
