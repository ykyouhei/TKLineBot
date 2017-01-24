//
//  DocomoError.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/23.
//
//

import Foundation
import SwiftyJSON
import KituraNet

/// DocomoAPIが返すエラーオブジェクト
public struct DocomoError: Swift.Error {
    
    public let messageId: String
    
    public let text: String
    
    init(object: Any) {
        let json = JSON(object)
        self.messageId = json["requestError"]["policyException"]["messageId"].string ?? ""
        self.text      = json["requestError"]["policyException"]["text"].string ?? ""
    }
}

public extension DocomoRequest {
    
    public func intercept(data: Data, clientResponse: ClientResponse) throws -> Data {
        guard 200..<300 ~= clientResponse.statusCode.rawValue else {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            throw DocomoError(object: object)
        }
        
        return data
    }
    
}
