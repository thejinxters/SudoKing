import Foundation

class OnePasswordLibrary {
    let opExecutable:String = "op"
    let config: OnePasswordConfig
    let opCli: OnePasswordCli
    let sessionManager: OnePasswordSessionManager
    
    init(config: OnePasswordConfig, cli: OnePasswordCli, sessionManager: OnePasswordSessionManager){
        self.config = config
        self.opCli = cli
        self.sessionManager = sessionManager
    }
    
    private func passwordShapeValidation(password: String) throws {
        if password.count < 10 {
            throw OnePasswordError.MinimumMasterPasswordError(
                message: "Master Password must be greater than 10 Characters"
            )
        }
    }
    
    private func signIn(password: String) throws {
        Log.debug("Attempting SignIn")
        try opCli.cli(
            binary: "echo \(password) | \(config.pathToOPBinary)",
            command: "signin my \(config.email) \(config.secretKey) --output=raw",
            friendlyError: "Invalid Password"
        ) { (sessionResponse) in
            if sessionResponse.exitCode == 0 {
                try self.sessionManager.createSession(session: sessionResponse.stdout)
            } else {
                throw OnePasswordError.OnePasswordCliError(message: "Invalid Password")
            }
        }
    }
    
    private func listPasswords() throws -> String {
        let sessonToken = sessionManager.getStoredSessionToken()!
        Log.debug("Retrieving list of OP Items")
        return try opCli.cli(
            binary: config.pathToOPBinary,
            command: "list items --session=\(sessonToken)",
            friendlyError: "Unable to retrieve password list"
        )
    }
    
    private func getPassword(_ uuid: String) throws -> String {
        let session = sessionManager.getStoredSessionToken()!
        return try opCli.cli(
            binary: config.pathToOPBinary,
            command: "get item \(uuid) --session=\(session)",
            friendlyError: "Unable to retrieve password"
        )
    }
    
    private func convertJsonToPasswordListItem(_ passwordListString: String) throws -> [OPListItem] {
        return try readJsonAs(
            type: [OPListItem].self,
            dataString: passwordListString,
            friendlyError: "Unable parse response from 1Password for password list retrieval"
        ) ?? []
    }
    
    private func convertJsonToPasswordItem(_ passwordDataString: String) throws -> OPPasswordItem {
        return try readJsonAs(
            type: OPPasswordItem.self,
            dataString: passwordDataString,
            friendlyError: "Unable to parse response from 1Password for password retrieval"
        )!
    }
    
    private func readJsonAs<T>(type: T.Type, dataString: String, friendlyError: String) throws -> T? where T : Decodable {
        var item: T?
        do {
            let decoder = JSONDecoder()
            let data = dataString.data(using: .utf8)!
            item = try decoder.decode(type, from: data)
        } catch let error as NSError {
            Log.error("Unable to parse json: \(error.description)")
            throw OnePasswordError.JsonParseError(message: "friendlyError")
        }
        return item
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
        return sessionManager.getStoredSessionToken() != nil
    }
}
