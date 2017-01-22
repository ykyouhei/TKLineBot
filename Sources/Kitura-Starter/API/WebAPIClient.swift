//
//  WebAPIClient.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import Result
import KituraRequest
import LoggerAPI

public enum WebAPIClientError: Swift.Error {
    case connectionError(Swift.Error)
    case responseError(Swift.Error)
}

public struct WebAPIClient<T: RequestProtocol> {
    
    public func send(request: T, completion: @escaping (Result<T.Response, WebAPIClientError>) -> Void) {
        
        let kituraRequest = request.buildURLRequest()
        
        kituraRequest.response { _, response, data, error in
            let result: Result<T.Response, WebAPIClientError>
            
            switch (data, response, error) {
            case (_, _, let error?):
                result = .failure(.connectionError(error))
                
            case (let data?, let urlResponse?, _):
                do {
                    result = .success(try request.parse(data: data, clientResponse: urlResponse))
                } catch {
                    result = .failure(.responseError(error))
                }
                
            default:
                result = .failure(.responseError(ResponseError.nonHTTPURLResponse(response)))
            }
            
            completion(result)
        }
    }
    
}
