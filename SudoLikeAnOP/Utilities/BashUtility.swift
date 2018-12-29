import Foundation

class BashUtility {
    
    static let shared = BashUtility()
    
    init() {}
    
    func run(_ args: String ...) throws -> BashCommandResponse {
        Log.debug("Creating Process for Bash Command")
        let command: String = args.joined(separator: " ")
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe
        // Necessary when Running via coprocess in iTerm to set the standardInput
        process.standardInput = FileHandle.nullDevice
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let stdout: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let stderr: String = NSString(data: errorData, encoding: String.Encoding.utf8.rawValue)! as String
        
        return BashCommandResponse(
            exitCode: process.terminationStatus,
            stdout: stdout,
            stderr: stderr
        )
    }
    
    struct BashCommandResponse  {
        var exitCode: Int32
        var stdout: String
        var stderr: String
    }
}
