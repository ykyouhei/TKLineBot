//
//  ObjectRequest.swift
//  Kitura-Starter
//
//  Created by 山口　恭兵 on 2017/03/19.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON
import S3SignerAWS

public extension S3API {
    
    enum Method {
        case get
        case put(data: Data)
        case delete
        
        var requestMethod: Request.Method {
            switch self {
            case .get:      return .get
            case .put:      return .put
            case .delete:   return .delete
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .get:      return .get
            case .put:      return .put
            case .delete:   return .delete
            }
        }
        
    }
    
    public struct BodyEncoding: Encoding {
        
        let data: Data
        
        public func encode(_ request: inout URLRequest, parameters: Request.Parameters?) throws {
            request.httpBody = data
        }
    }
    
    public struct ObjectRequest: S3Request {
        
        public let fileName: String
        
        public let s3method: Method
        
        public var method: Request.Method {
            return s3method.requestMethod
        }
        
        public var path: String {
            return "/images/\(fileName)"
        }
        
        public var headerFields: [String : String] {
            let payload: Payload
            
            switch s3method {
            case .get:           payload = .none
            case .put(let data): payload = .bytes(try! data.makeBytes())
            case .delete:        payload = .none
            }
            
            let header = try! s3Signer.authHeaderV4(httpMethod: s3method.httpMethod,
                                         urlString: baseURL.absoluteString + path,
                                         headers: [:],
                                         payload: payload)
            
            return header
        }
        
        public var encoding: Encoding {
            switch s3method {
            case .get:           return URLEncoding.default
            case .put(let data): return BodyEncoding(data: data)
            case .delete:        return URLEncoding.default
            }
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> Data {
            return data
        }
    }
    
}
