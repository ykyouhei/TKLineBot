//
//  LineBotServer.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/21.
//
//

import Foundation
import Kitura
import LoggerAPI
import SwiftyJSON

/// LineのWebHookを受け取るサーバ
public class LineBotServer: RouterMiddleware {

    /// Handle an incoming HTTP request.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the HTTP request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       HTTP request
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    ///
    /// - Throws: Any `ErrorType`. If an error is thrown, processing of the request
    ///          is stopped, the error handlers, if any are defined, will be invoked,
    ///          and the user will get a response with a status code of 500.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("POST - /linebot...")
        Log.debug("\(request)")
        
        if let jsonString = try request.readString() {
            let json   = JSON(jsonString)
            let events = json["events"].arrayValue
            
            events.forEach {
                routeEvent(eventJSON: $0)
            }
        }
        
        try response.status(.OK).end()
    }
    
    private func routeEvent(eventJSON: JSON) {
        guard let type      = eventJSON["type"].string,
              let eventType = EventType(rawValue: type) else {
                return
        }
        
        Log.info("Received \(type) event ")
        
        switch eventType {
        case .message:
            routeMessageEvent(eventJSON: eventJSON)
            
        default:
            break
        }
    }
    
    private func routeMessageEvent(eventJSON: JSON) {
        guard let messageTypeRaw = eventJSON["message"]["type"].string,
              let messageType    = MessageType(rawValue: messageTypeRaw) else {
                return
        }
        
        switch messageType {
        case .text:
            let textMessageEvent = MessageEvent<TextMessage>(json: eventJSON)
            Log.debug("\(textMessageEvent)")
            
        case .image:    break
        case .video:    break
        case .audio:    break
        case .location: break  
        case .sticker:  break
        }
    }
    
}
