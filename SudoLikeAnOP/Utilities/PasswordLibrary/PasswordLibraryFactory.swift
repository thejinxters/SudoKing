import Foundation

class PasswordLibraryFactory {
    private static let passwordLibrary: PasswordLibrary = OnePasswordLibrary(
        config: OnePasswordConfigManager.shared,
        cli: OnePasswordCli(bashUtility: BashUtility.shared),
        sessionManager: OnePasswordSessionManager(config: OnePasswordConfigManager.shared)
    )
    
    static let shared: PasswordLibrary = passwordLibrary
}
