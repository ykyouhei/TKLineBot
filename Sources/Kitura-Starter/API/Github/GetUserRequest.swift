//
//  GetUserRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/23.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension GitHubAPI {
    
    public struct GetUserRequest: GitHubRequest {
        
        public let userName: String
        
        public var method: Request.Method {
            return .get
        }
        
        public var path: String {
            return "/users/\(userName)"
        }
        
        public var encoding: Encoding {
            return URLEncoding.default
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> User {
            let json = JSON(data: data)
            return User(json)
        }
    }

}

public extension GitHubAPI {
    
    public struct User: CustomStringConvertible {
        
        public let login: String
        public let url: URL
        public let htmlUrl: URL
        public let publicRepos: Int
        
        init(_ json: JSON) {
            self.login       = json["login"].stringValue
            self.url         = URL(string: json["url"].stringValue)!
            self.htmlUrl     = URL(string: json["html_url"].stringValue)!
            self.publicRepos = json["public_repos"].intValue
        }
    }
   
}
