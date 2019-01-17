import Foundation
@testable import SudoKing

class BashUtilitySpy: BashUtility {
    var responsesToReturn: [BashUtility.BashCommandResponse] = []
    
    
    override func run(_ args: String...) throws -> BashUtility.BashCommandResponse {
        if responsesToReturn.count > 0 {
            return responsesToReturn.popLast()!
        }
        throw BashUtilitySpyError.noResponsesSetToReturn
    }
    
    func addResponseToReturn(response: BashUtility.BashCommandResponse) {
        responsesToReturn.append(response)
    }
    
    func reset() {
        responsesToReturn = []
    }
}


enum BashUtilitySpyError: Error {
    case noResponsesSetToReturn
}
