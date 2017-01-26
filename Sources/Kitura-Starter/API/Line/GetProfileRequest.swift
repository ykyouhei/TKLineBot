//
//  GetProfileRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/25.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension LineAPI {
    
    /// https://devdocs.line.me/ja/#bot-api-get-profile
    ///
    /// ユーザのプロフィール情報を取得する
    public struct GetProfileRequest: LineRequest, CustomStringConvertible {
        
        /// ユーザ識別子
        /// `userId`には、webhookで受信した送信元ユーザの識別子を指定してください。
        /// LINEアプリで使用されているLINE IDは指定できません。
        public let userId: String
        
        
        public var method: Request.Method {
            return .get
        }
        
        public var path: String {
            return "/profile/\(userId)"
        }
        
        public var encoding: Encoding {
            return URLEncoding.default
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> Profile {
            let json = JSON(data: data)
            return Profile(json: json)
        }
    }
   
}


public extension LineAPI {
    
    /// ユーザのプロフィール情報
    public struct Profile: CustomStringConvertible {
        
        /// 表示名
        let displayName: String
        
        /// ユーザ識別子
        let userId: String
        
        /// 画像URL
        let pictureUrl: URL
        
        /// ステータスメッセージ
        let statusMessage: String
        
        init(json: JSON) {
            self.displayName   = json["displayName"].stringValue
            self.userId        = json["userId"].stringValue
            self.pictureUrl    = URL(string: json["pictureUrl"].stringValue)!
            self.statusMessage = json["statusMessage"].stringValue
        }
        
    }
    
}
