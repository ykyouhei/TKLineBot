//
//  GitHubError.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import SwiftyJSON
import KituraNet

/// GitHubAPIが返すエラーオブジェクト
public struct GitHubError: Swift.Error {
    
    public let message: String
    
    init(object: Any) {
        let json = JSON(object)
        self.message = json["message"].string ?? "Unknown error occurred"
    }
}

public extension GitHubRequest {
    
    public func intercept(data: Data, clientResponse: ClientResponse) throws -> Data {
        guard 200..<300 ~= clientResponse.statusCode.rawValue else {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            throw GitHubError(object: object)
        }
        
        return data
    }
    
}
