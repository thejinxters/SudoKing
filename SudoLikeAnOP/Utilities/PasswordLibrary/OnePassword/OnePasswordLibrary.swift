import Foundation

class OnePasswordLibrary {
    let opExecutable:String = "op"
    let config = OnePasswordConfigManager.shared
    
    private func signIn(password: String) -> Bool {
        Log.debug("Retrieving an new session")
        if (OnePasswordSessionManager.getStoredSession() == nil) {
            do {
                let session = try bash("echo \(password) | \(config.pathToOPBinary) signin my \(config.email) \(config.secretKey) --output=raw")
                if session.exitCode == 0 {
                    return OnePasswordSessionManager.createSession(session: session.stdout)
                } else {
                    Log.error("Error Sigining in: \(session.stderr)")
                    return false
                }
            } catch let error as NSError {
                Log.error("Error Signing in: \(error.description)")
                return false
            }
        } else {
            return true
        }
    }
    
    private func listPasswords() -> String {
        let session = OnePasswordSessionManager.getStoredSession()!
        Log.debug("Retrieving list of OP Items")
        do {
            let listResponse = try bash("\(config.pathToOPBinary) list items --session=\(session)")
            return listResponse.stdout
        } catch let error as NSError {
            Log.error("Error Signing in: \(error.description)")
            return "[]" // Empty Array
        }
    }
    
    private func getPassword(_ uuid: String) -> String {
        let session = OnePasswordSessionManager.getStoredSession()!
        do {
            return try bash("\(config.pathToOPBinary) get item \(uuid) --session=\(session)").stdout
        } catch let error as NSError {
            Log.error("Error getting Password: \(error.description)")
            return ""
        }
    }
    
    private func convertJsonToPasswordListItem(_ passwordListString: String) -> [OPListItem] {
        var list: [OPListItem]?
        do {
            let decoder = JSONDecoder()
            let data = passwordListString.data(using: .utf8)!
            list = try decoder.decode([OPListItem].self, from: data)
        } catch let error as NSError {
            Log.error("Unable to parse json: \(error.description)")
        }
        
        return list!
    }
    
    private func convertJsonToPasswordItem(_ passwordDataString: String) -> OPPasswordItem {
        var item: OPPasswordItem?
        
        do {
            let decoder = JSONDecoder()
            let data = passwordDataString.data(using: .utf8)!
            item = try decoder.decode(OPPasswordItem.self, from: data)
        } catch let error as NSError {
            Log.error("Unable to parse json: \(error.description)")
        }
        
        return item!
    }
}

extension OnePasswordLibrary: PasswordLibrary {
    func validateMasterPassword(password: String) -> Bool {
        return signIn(password: password)
    }
    
    func retrievePasswordList() -> [PasswordListItem] {
        let passwordList: String = listPasswords()
        let listItems: [OPListItem] = convertJsonToPasswordListItem(passwordList)
        
        return listItems.map { (opListItem) -> PasswordListItem in
            return PasswordListItem(
                uuid: opListItem.uuid,
                name: opListItem.overview.title,
                urls: opListItem.overview.URLs.map({ (opUrls) -> [String] in
                    opUrls.map({ (opUrl) -> String in opUrl.u })
                }),
                tags: opListItem.tags
            )
        }
    }
    
    func retrievePassword(uuid: String) -> String? {
        let passwordResponse: String = getPassword(uuid)
        let passwordItem: OPPasswordItem = convertJsonToPasswordItem(passwordResponse)
        
        let password = passwordItem.details.fields.first { (field) -> Bool in
            return field.name == "password"
        }
        
        return password?.value
    }
    
    func validSessionActive() -> Bool {
        return OnePasswordSessionManager.getStoredSession() != nil
    }
}
