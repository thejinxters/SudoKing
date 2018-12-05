import Foundation

class OnePasswordLibrary {
    
    class func validatePassword(password: String) -> Bool {
        return password == "mypass"
    }
    
    class func retrievePasswordList() -> [PasswordListItem] {
        let resp: String = bash(command:"\"cat /Users/bmikulka/Downloads/talia.json\"", arguments: [""])
        let data: Data = resp.data(using: .utf8, allowLossyConversion: false)!
        var passwordItems: [PasswordListItem] = []
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            passwordItems = json.map { (item) -> PasswordListItem in
                let overview = item["overview"] as! [String:AnyObject]
                let urls = overview["URLs"] as? [[String:String]]
                return PasswordListItem.init(
                    uuid: item["uuid"] as! String,
                    name: overview["title"] as! String,
                    urls: urls?.map({ (url) -> String in
                        return url["u"]!
                    }),
                    tags: item["tags"] as? [String])
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return passwordItems
    }
    
    class func retrievePassword(uuid: String) -> String? {
        let passwords = [
            "abc123": "secret1",
            "efg456": "secret2",
            "hij789": "secret3"
        ]
        return passwords[uuid]
    }
    
    class func shell(path: String, args: [String]) -> String {
        let task = Process()
        task.launchPath = path
        task.arguments = args
        
        let pipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = pipe
        task.standardError = errorPipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: String.Encoding.utf8)!
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errors: String = String(data: errorData, encoding: String.Encoding.utf8)!
        if !errors.isEmpty {
            Log.error(message: errors)
        }
        let trimmed = output.trimmingCharacters(in: NSCharacterSet.newlines)
        return trimmed
    }
    
    private class func bash(command: String, arguments: [String]) -> String {
        return shell(path: "/bin/bash", args: ["-l", "-c", command] )
//        return shell(path: whichPathForCommand, args: arguments)
    }
}

struct PasswordListItem {
    var uuid: String
    var name: String
    var urls: [String]?
    var tags: [String]?
}
