//
//  Request.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import KituraRequest
import KituraNet
import LoggerAPI

public enum ResponseError: Swift.Error {
    /// Indicates the session adapter returned `URLResponse` that fails to down-cast to `HTTPURLResponse`.
    case nonHTTPURLResponse(ClientResponse?)
    
    /// Indicates `HTTPURLResponse.statusCode` is not acceptable.
    /// In most cases, *acceptable* means the value is in `200..<300`.
    case unacceptableStatusCode(HTTPStatusCode)
    
    /// Indicates `Any` that represents the response is unexpected.
    case unexpectedObject(Any)
}


public protocol RequestProtocol {
    
    associatedtype Response
    
    var baseURL: URL { get }
    
    var method: Request.Method { get }
    
    var path: String { get }
    
    var parameters: Request.Parameters? { get }
    
    var encoding: Encoding { get }
    
    var headerFields: [String: String] { get }
    
    func intercept(data: Data, clientResponse: ClientResponse) throws -> Data
    
    func response(from data: Data, clientResponse: ClientResponse) throws -> Response
}

public extension RequestProtocol {
    
    public var parameters: Request.Parameters? {
        return nil
    }
    
    public var headerFields: [String: String] {
        return [:]
    }
    
    public func intercept(data: Data, clientResponse: ClientResponse) throws -> Data {
        guard (200..<300).contains(clientResponse.statusCode.rawValue) else {
            throw ResponseError.unacceptableStatusCode(clientResponse.statusCode)
        }
        return data
    }
    
    public func buildURLRequest() -> Request {
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        
        let request = KituraRequest.request(
            method,
            url.absoluteString,
            parameters: parameters,
            encoding: encoding,
            headers: headerFields)
        
        Log.debug("URL: \(url.absoluteString)")
        Log.debug("Parameters: \(parameters)")
        Log.debug("Headers: \(headerFields)")
        
        return request
    }
    
    public func parse(data: Data, clientResponse: ClientResponse) throws -> Response {
        let interceptData = try intercept(data: data, clientResponse: clientResponse)
        return try response(from: interceptData, clientResponse: clientResponse)
    }
}
