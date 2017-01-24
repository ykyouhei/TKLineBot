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
        case logLevel           = "LOGLEVEL"
        case lineAccessToken    = "LINE_CHANNEL_ACCESS_TOKEN"
        case githubAccessToken  = "GITHUB_ACCESS_TOKEN"
        case docomoClientId     = "DOCOMO_CLIENT_ID"
        case docomoClientSecret = "DOCOMO_CLIENT_SECRET"
        case docomoAPIKey       = "DOCOMO_API_KEY"
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
