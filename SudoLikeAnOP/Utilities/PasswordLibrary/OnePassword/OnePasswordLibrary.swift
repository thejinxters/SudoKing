import Foundation
import SwiftShell

class OnePasswordLibrary {
    let opExecutable:String = "op"
    
    private func listPasswords() -> String {
        return run("cat", "/Users/bmikulka/Downloads/talia.json").stdout
    }
    
    private func getPassword(_ uuid: String) -> String {
        return run("cat", "/Users/bmikulka/Downloads/talia-p.json").stdout
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
        return password == "mypass"
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
}
