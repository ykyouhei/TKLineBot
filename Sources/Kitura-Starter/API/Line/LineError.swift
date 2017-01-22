//
//  LineError.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import SwiftyJSON
import KituraNet

/// LineAPIが返すエラーオブジェクト
public struct LineError: Swift.Error {
    
    public typealias Detail = (message: String, property: String)
    
    public let message: String
    
    public let details: [Detail]?
    
    init(object: Any) {
        let json = JSON(object)
        
        self.message = json["message"].stringValue
        
        if let detailJSON = json["details"].array {
            self.details = detailJSON.map {
                return (message:  $0["message"].stringValue,
                        property: $0["property"].stringValue)
            }
        } else {
            self.details = nil
        }
    }
}

public extension LineRequest {
    
    public func intercept(data: Data, clientResponse: ClientResponse) throws -> Data {
        guard 200..<300 ~= clientResponse.statusCode.rawValue else {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            throw LineError(object: object)
        }
        
        return data
    }
    
}
