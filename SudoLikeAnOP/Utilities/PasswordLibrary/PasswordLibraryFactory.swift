import Foundation

class PasswordLibraryFactory {
    private static let passwordLibrary: PasswordLibrary = OnePasswordLibrary()
    
    static let shared: PasswordLibrary = passwordLibrary
}
