import Foundation

class PasswordLibraryFactory {
    
    private let libraryType: String
    
    
    init(_ libraryType: String) {
        self.libraryType = libraryType
    }
    
    private func passwordLibrary() -> PasswordLibrary? {
        switch libraryType {
        case "op":
            return OnePasswordLibrary(
                config: OnePasswordConfigManager.shared,
                cli: OnePasswordCli(bashUtility: BashUtility.shared),
                sessionManager: OnePasswordSessionManager(config: OnePasswordConfigManager.shared)
            )
        case "test":
            return OnePasswordLibrary(
                config: OnePasswordConfigManager.shared,
                cli: OnePasswordCli(bashUtility: BashUtility.shared),
                sessionManager: OnePasswordSessionManager(config: OnePasswordConfigManager.shared)
            )
        default:
            return nil
        }
    }
    
    static let shared: PasswordLibrary = PasswordLibraryFactory("op").passwordLibrary()!
}
