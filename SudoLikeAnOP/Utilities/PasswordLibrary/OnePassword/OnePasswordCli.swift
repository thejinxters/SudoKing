//
//  OnePasswordCli.swift
//  SudoLikeAnOP
//
//  Created by Brandon Mikulka on 12/21/18.
//  Copyright © 2018 Russell Teabeault. All rights reserved.
//

import Foundation

class OnePasswordCli {
    @discardableResult static func opCli(
        binary: String,
        command: String,
        friendlyError: String,
        fn: ((BashCommandResponse) throws -> Void)? = nil
        ) throws -> String {
        do{
            let response = try bash("\(binary) \(command)")
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
