//
//  MessageRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/02/19.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension MitsunoAPI {
    
    public struct MessageRequest: MitsunoRequest {
        
        public let message: String
        
        public var method: Request.Method {
            return .post
        }
        
        public var path: String {
            return "/tanaka"
        }
        
        public var encoding: Encoding {
            return JSONEncoding.default
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> Message {
            let json = JSON(data: data)
            return Message(json)
        }
    }
    
}

public extension MitsunoAPI {
    
    public struct Message: CustomStringConvertible {
        
        public let message: String
        
        init(_ json: JSON) {
            self.message = json["message"].stringValue
        }
    }
    
}
