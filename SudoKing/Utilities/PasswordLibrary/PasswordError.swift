import Foundation

protocol PasswordError: Error {
    var message: String { get }
}
