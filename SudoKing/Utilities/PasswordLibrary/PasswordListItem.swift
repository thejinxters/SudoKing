import Foundation

struct PasswordListItem: Equatable {
    
    var uuid: String
    var name: String
    var tags: [String]?
    
    static func == (lhs: PasswordListItem, rhs: PasswordListItem) -> Bool {
        return lhs.name == rhs.name && lhs.uuid == rhs.uuid && lhs.tags  == rhs.tags
    }
}
