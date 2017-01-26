//
//  Log+PrintError.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/25.
//
//

import Foundation
import LoggerAPI

extension Log {
    
    static var printError: (Error) -> Void {
        return {
            Log.error("\($0)")
        }
    }
    
}
