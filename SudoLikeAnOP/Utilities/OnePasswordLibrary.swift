import Foundation

class OnePasswordLibrary {
    
    class func validatePassword(password: String) -> Bool {
        return password == "mypass"
    }
    
    class func retrievePasswordList() -> [PasswordListItem] {
        return [
            PasswordListItem.init(uuid: "abc123", name: "Password1", urls: ["http://google.com"], tags: ["tag1"]),
            PasswordListItem.init(uuid: "efg456", name: "Password2", urls: nil, tags: nil),
            PasswordListItem.init(uuid: "hij789", name: "Password3", urls: nil, tags: nil)
        ]
    }
    
    class func retrievePassword(uuid: String) -> String? {
        let passwords = [
            "abc123": "secret1",
            "efg456": "secret2",
            "hij789": "secret3"
        ]
        return passwords[uuid]
    }
}

struct PasswordListItem {
    var uuid: String
    var name: String
    var urls: [String]?
    var tags: [String]?
}
