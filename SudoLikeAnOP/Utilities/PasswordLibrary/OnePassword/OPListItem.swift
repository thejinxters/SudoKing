import Foundation

struct OPListItem: Codable {
    var overview: OPOverview
    var uuid: String
    
    struct OPOverview: Codable {
        var title: String
        var tags: [String]?
    }
        
    func toPasswordListItem() -> PasswordListItem {
        return PasswordListItem(
            uuid: self.uuid,
            name: self.overview.title,
            tags: self.overview.tags
        )
    }
}
