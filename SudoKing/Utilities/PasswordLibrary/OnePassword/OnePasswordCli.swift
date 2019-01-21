//
//  OnePasswordCli.swift
//  SudoKing
//
//  Created by Brandon Mikulka on 12/21/18.
//  Copyright © 2018 Russell Teabeault. All rights reserved.
//

import Foundation

class OnePasswordCli {
    
    let bash: BashUtility
    
    init(bashUtility: BashUtility){
        self.bash = bashUtility
    }
    
    @discardableResult func cli(
        binary: String,
        command: String,
        friendlyError: String,
        fn: ((BashUtility.BashCommandResponse) throws -> Void)? = nil
        ) throws -> String {
        do{
            let response = try bash.run("\(binary) \(command)")
            if response.exitCode != 0 {
                Log.error("Bash error stderr:\(response.stderr)")
            }
            try fn.map { (runFn) -> Void in
                try runFn(response)
            }
            return response.stdout
        } catch let error as NSError {
            Log.error("Error running 'op \(command)': \(error.description)")
            throw OnePasswordError.OnePasswordCliError(message: friendlyError)
        }
    }
}
