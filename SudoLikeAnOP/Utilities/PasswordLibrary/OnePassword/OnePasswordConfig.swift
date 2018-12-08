import Foundation

struct OnePasswordConfig: Codable {
    var subdomain: String
    var email: String
    var secretKey: String
    var pathToOPBinary: String
    var sessionExpirationMinutes: Double
}
