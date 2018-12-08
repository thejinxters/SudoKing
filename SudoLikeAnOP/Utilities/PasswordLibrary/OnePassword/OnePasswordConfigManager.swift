import Foundation


class OnePasswordConfigManager {
    private static let homeURL = FileManager.default.homeDirectoryForCurrentUser
    private static let settingsDirectoryURL = homeURL.appendingPathComponent(".sudolikeanop")
    private static let configFileURL = settingsDirectoryURL.appendingPathComponent("config")
    
    static let shared: OnePasswordConfig = try! readJsonConfig()
    
    private static func readJsonConfig() throws -> OnePasswordConfig {
        Log.debug("Loading OnePassword config from \(configFileURL.path)")
        var fileContents:String = ""
        if configExists() {
            fileContents = try String(contentsOf: configFileURL)
        } else {
            Log.error("Config file does not exist")
            throw ConfigLoaderError.configFileDoesNotExist
        }
        let decoder = JSONDecoder()
        let data = fileContents.data(using: .utf8)!
        return try decoder.decode(OnePasswordConfig.self, from: data)
    }
    
    static func writeNewConfig(onePasswordConfig: OnePasswordConfig) throws {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(onePasswordConfig)
        let ouputString = String(data: data, encoding: .utf8)!
        
        if !FileManager.default.fileExists(atPath: settingsDirectoryURL.path) {
            try FileManager.default.createDirectory(atPath: settingsDirectoryURL.path, withIntermediateDirectories: false)
        }
    
        try ouputString.write(to: configFileURL, atomically: true, encoding: .utf8)
    }
    
    static func configExists() -> Bool {
        return FileManager.default.fileExists(atPath: configFileURL.path)
    }
}

enum ConfigLoaderError: Error {
    case configFileDoesNotExist
}
