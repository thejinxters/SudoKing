import Foundation

enum OnePasswordError: PasswordError {
    case MinimumMasterPasswordError(message: String)
    case SignInError(message: String)
    case ListRetrievalError(message: String)
    case PasswordRetrievalError(message: String)
    case JsonParseError(message: String)
    case SessionError(message: String)
}

extension OnePasswordError {
    var message: String {
        switch self {
        case let .MinimumMasterPasswordError(message):
            return message
        case let .SignInError(message):
            return message
        case let .ListRetrievalError(message):
            return message
        case let .PasswordRetrievalError(message):
            return message
        case let .JsonParseError(message):
            return message
        case let .SessionError(message):
            return message
        }
    }
}
