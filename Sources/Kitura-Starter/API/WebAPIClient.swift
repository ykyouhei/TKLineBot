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
import then

public enum WebAPIClientError: Swift.Error {
    case connectionError(Swift.Error)
    case responseError(Swift.Error)
}

public struct WebAPIClient<T: RequestProtocol> {
    
    public func send(_ request: T) -> Promise<T.Response> {
        return Promise { resolve, reject in
            
            let kituraRequest = request.buildURLRequest()
            
            kituraRequest.response { _, response, data, error in
                switch (data, response, error) {
                case (_, _, let error?):
                    reject(WebAPIClientError.connectionError(error))
                    
                case (let data?, let urlResponse?, _):
                    do {
                        let parsedResponse = try request.parse(data: data, clientResponse: urlResponse)
                        
                        let log = [
                            "======= API Response ======",
                            "\(parsedResponse)"
                        ].joined(separator: "\n")
                        
                        Log.debug(log)
                        
                        resolve(parsedResponse)
                    } catch let responseError {
                        reject(WebAPIClientError.responseError(responseError))
                    }
                    
                default:
                    reject(WebAPIClientError.responseError(ResponseError.nonHTTPURLResponse(response)))
                }
            }
        }
    }
    
}
