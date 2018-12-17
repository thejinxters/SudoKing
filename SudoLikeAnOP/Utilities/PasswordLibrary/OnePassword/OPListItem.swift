import Foundation

struct OPListItem: Codable {
    var overview: OPOverview
    var uuid: String
    var tags: [String]?
    
    struct OPOverview: Codable {
        var title: String
        var URLs: [OPUrl]?
    }
    
    struct OPUrl: Codable {
        var u: String
    }
    
    func toPasswordListItem() -> PasswordListItem {
        return PasswordListItem(
            uuid: self.uuid,
            name: self.overview.title,
            urls: self.overview.URLs.map({ (opUrls) -> [String] in
                opUrls.map({ (opUrl) -> String in opUrl.u })
            }),
            tags: self.tags
        )
    }
}
