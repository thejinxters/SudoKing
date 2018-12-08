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
}
