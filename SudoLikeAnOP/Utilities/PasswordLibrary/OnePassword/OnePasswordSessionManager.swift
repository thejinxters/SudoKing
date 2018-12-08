import Foundation

class OnePasswordSessionManager {
    
    private static let homeURL = FileManager.default.homeDirectoryForCurrentUser
    private static let settingsDirectoryURL = homeURL.appendingPathComponent(".sudolikeanop")
    private static let sessionFileURL = settingsDirectoryURL.appendingPathComponent("session")
    private static let tenMinutesInSeconds = OnePasswordConfigManager.shared.sessionExpirationMinutes * 60.0
    
    class func getStoredSession() -> String? {
        Log.debug("Loading session from \(sessionFileURL.path)")
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
                Log.debug("No session stored")
                return nil
            }
            
        } catch let error as NSError {
            Log.error("Unable to load session: \(error.description)")
            return nil
        }
    }
    
    class func createSession(session: String) -> Bool {
        Log.info("Storing new Session at \(sessionFileURL.path)")
        
        let newSession = Session(
            token: session,
            expiration: Date().addingTimeInterval(tenMinutesInSeconds)
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
            Log.error("Unable to store session: \(error.description)")
            return false
        }
        
        return true
    }
    
    struct Session: Codable {
        var token: String
        var expiration: Date
    }
    
}