//
//  Environment.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import LoggerAPI


/// 環境変数アクセス用クラス
public class Environment {
    
    enum EnvironmentName: String {
        case appHost         = "VCAP_APP_HOST"
        case logLevel        = "LOGLEVEL"
        case lineAccessToken = "LINE_CHANNEL_ACCESS_TOKEN"
    }
    
    static func get(_ name: EnvironmentName) -> String {
        let env = ProcessInfo.processInfo.environment
        if let value = env[name.rawValue] {
            return value
        } else {
            Log.warning("環境変数 \(name.rawValue) が存在しません")
            return ""
        }
    }
    
    private init() {}
    
}
