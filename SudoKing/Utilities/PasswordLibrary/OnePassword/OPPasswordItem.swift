import Foundation

struct OPPasswordItem: Codable {
    var details: OPDetails
    
    struct OPDetails: Codable {
        var fields: [Field]
    }
    
    struct Field: Codable {
        var name: String
        var type: String
        var value: String
    }
}
