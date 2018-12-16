import Foundation


enum OnePasswordError: PasswordError {
    case MinimumMasterPasswordError(message: String)
    case SignInError(message: String)
    case SessionError(message: String)
}

extension OnePasswordError {
    var message: String {
        switch self {
        case .MinimumMasterPasswordError(let message):
            return message
        case .SignInError(let message):
            return message
        case .SessionError(let message):
            return message
        }
        
    }
}
