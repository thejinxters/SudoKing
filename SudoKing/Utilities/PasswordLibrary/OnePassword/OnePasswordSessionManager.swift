import Foundation

class OnePasswordSessionManager {
    
    private let homeURL: URL
    private let settingsDirectoryURL: URL
    private let sessionFileURL: URL
    private let sessionExpirationInSeconds: Double
    
    init(config: OnePasswordConfig) {
        homeURL = FileManager.default.homeDirectoryForCurrentUser
        settingsDirectoryURL = homeURL.appendingPathComponent(".sudoking")
        sessionFileURL = settingsDirectoryURL.appendingPathComponent("session")
        sessionExpirationInSeconds = config.sessionExpirationMinutes * 60.0
    }
    
    func getStoredSessionToken() -> String? {
        Log.debug("Session Manager: Loading session from \(sessionFileURL.path)")
        do {
            var fileContents:String = ""
            if FileManager.default.fileExists(atPath: sessionFileURL.path) {
                fileContents = try String(contentsOf: sessionFileURL)
                let decoder = JSONDecoder()
                let data = fileContents.data(using: .utf8)!
                let session = try decoder.decode(Session.self, from: data)
                if Date() < session.expiration {
                    return session.token
                } else {
                    return nil
                }
            } else {
                Log.debug("Session Manager: No session stored")
                return nil
            }
            
        } catch let error as NSError {
            Log.error("Session Manager unable to load session: \(error.description)")
            return nil
        }
    }
    
    func createSession(session: String) throws {
        Log.info("Session Manager: Storing new Session at \(sessionFileURL.path)")
        
        let newSession = Session(
            token: session,
            expiration: Date().addingTimeInterval(sessionExpirationInSeconds)
        )
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(newSession)
            let ouputString = String(data: data, encoding: .utf8)!
            
            if !FileManager.default.fileExists(atPath: settingsDirectoryURL.path) {
                try FileManager.default.createDirectory(atPath: settingsDirectoryURL.path, withIntermediateDirectories: false)
            }
            try ouputString.write(to: sessionFileURL, atomically: true, encoding: .utf8)
            
        } catch let error as NSError {
            Log.error("Session Manager unable to store session: \(error.description)")
            throw OnePasswordError.SessionError(message: "Unable to create Session")
        }
    }
    
    struct Session: Codable {
        var token: String
        var expiration: Date
    }
    
}
