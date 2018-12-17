import Foundation

class OnePasswordLibrary {
    let opExecutable:String = "op"
    let config = OnePasswordConfigManager.shared
    
    private func passwordShapeValidation(password: String) throws {
        if password.count < 10 {
            throw OnePasswordError.MinimumMasterPasswordError(
                message: "Master Password must be greater than 10 Characters"
            )
        }
    }
    
    private func signIn(password: String) throws {
        Log.debug("Attempting SignIn")
        let sessionResponse = try bash("echo \(password) | \(config.pathToOPBinary) signin my \(config.email) \(config.secretKey) --output=raw")
        if sessionResponse.exitCode == 0 {
            try OnePasswordSessionManager.createSession(session: sessionResponse.stdout)
        } else {
            Log.error("Error Sigining in: \(sessionResponse.stderr)")
            throw OnePasswordError.SignInError(message: "Invalid Password")
        }
    }
    
    private func listPasswords() throws -> String {
        let sessonToken = OnePasswordSessionManager.getStoredSessionToken()!
        Log.debug("Retrieving list of OP Items")
        do {
            let listResponse = try bash("\(config.pathToOPBinary) list items --session=\(sessonToken)")
            return listResponse.stdout
        } catch let error as NSError {
            Log.error("Unable to retrieve OP items: \(error.description)")
            throw OnePasswordError.ListRetrievalError(message: "Unable to retrieve password list")
        }
    }
    
    private func getPassword(_ uuid: String) throws -> String {
        let session = OnePasswordSessionManager.getStoredSessionToken()!
        do {
            return try bash("\(config.pathToOPBinary) get item \(uuid) --session=\(session)").stdout
        } catch let error as NSError {
            Log.error("Error getting Password: \(error.description)")
            throw OnePasswordError.PasswordRetrievalError(message: "Unable to retrieve password")
        }
    }
    
    private func convertJsonToPasswordListItem(_ passwordListString: String) throws -> [OPListItem] {
        var list: [OPListItem] = []
        do {
            let decoder = JSONDecoder()
            let data = passwordListString.data(using: .utf8)!
            list = try decoder.decode([OPListItem].self, from: data)
        } catch let error as NSError {
            Log.error("Unable to parse json: \(error.description)")
            throw OnePasswordError.JsonParseError(message: "Unable parse response from 1Password for password list retrieval")
        }
        return list
    }
    
    private func convertJsonToPasswordItem(_ passwordDataString: String) throws -> OPPasswordItem {
        var item: OPPasswordItem?
        do {
            let decoder = JSONDecoder()
            let data = passwordDataString.data(using: .utf8)!
            item = try decoder.decode(OPPasswordItem.self, from: data)
        } catch let error as NSError {
            Log.error("Unable to parse json: \(error.description)")
            throw OnePasswordError.JsonParseError(message: "Unable to parse response from 1Password for password retrieval")
        }
        return item!
    }
}

extension OnePasswordLibrary: PasswordLibrary {
    func validateMasterPassword(password: String) throws {
        try passwordShapeValidation(password: password)
        try signIn(password: password)
    }
    
    func retrievePasswordList() throws -> [PasswordListItem] {
        let passwordList: String = try listPasswords()
        let listItems: [OPListItem] = try convertJsonToPasswordListItem(passwordList)
        return listItems.map { $0.toPasswordListItem() }
    }
    
    func retrievePassword(uuid: String) throws -> String {
        let passwordResponse: String = try getPassword(uuid)
        let passwordItem: OPPasswordItem = try convertJsonToPasswordItem(passwordResponse)
        let password = passwordItem.details.fields.first { $0.name == "password" }
        if password == nil {
            throw OnePasswordError.PasswordRetrievalError(message: "No password for selected item")
        }
        return password!.value
    }
    
    func validSessionActive() -> Bool {
        return OnePasswordSessionManager.getStoredSessionToken() != nil
    }
}
