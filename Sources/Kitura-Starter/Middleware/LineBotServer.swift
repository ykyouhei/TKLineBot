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
import Regex
import Dispatch

/// LineのWebHookを受け取るサーバ
public class LineBotServer: RouterMiddleware {
    
    
    /// LineからのWebhookを受け取った際に呼ばれる
    ///
    /// - Parameters:
    ///   - request:  RouterRequest
    ///   - response: RouterResponse
    ///   - next:
    /// - Throws:
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let jsonString = try request.readString() else {
            try response.status(.OK).end()
            return
        }
        
        let json   = JSON.parse(string: jsonString)
        let events = json["events"].arrayValue
        
        events.forEach { event in
            DispatchQueue.global().async {
                self.routeEvent(eventJSON: event)
            }
        }
    
        try response.status(.OK).end()
    }
    
    
    // MARK: - Private Method
    

    // TODO: 受け取ったメッセージのRouting
    private func routeEvent(eventJSON: JSON) {
        guard let type      = eventJSON["type"].string,
              let eventType = EventType(rawValue: type) else {
                return
        }
        
        Log.info("========= Received \(type) event ==========")
        
        switch eventType {
        case .message:
            routeMessageEvent(eventJSON: eventJSON)
            
        case .beacon:   break
        case .follow:   break
        case .join:     break
        case .leave:    break
        case .postback: break
        case .unfollow: break
        }
    }
    
    
    /// MessageEventのRouting
    ///
    /// - Parameter eventJSON: JSON
    private func routeMessageEvent(eventJSON: JSON) {
        guard let messageTypeRaw = eventJSON["message"]["type"].string,
              let messageType    = MessageEventType(rawValue: messageTypeRaw) else {
                return
        }
        
        Log.info("========= MessageType is \(messageType) ==========")
        Log.debug("\(eventJSON)")
        
        switch messageType {
        case .text:     handle(textMessageEvent: MessageEvent<TextMessage>(json: eventJSON))
        case .image:    handle(imageMessageEvent: MessageEvent<ImageMessage>(json: eventJSON))
        case .video:    storeContent(messageEvent: MessageEvent<VideoMessage>(json: eventJSON))
        case .audio:    break
        case .location: break  
        case .sticker:  break
        }
    }
    
    /// TextMessageを受信した際の処理
    ///
    /// - Parameter textMessageEvent: MessageEvent<TextMessage>
    private func handle(textMessageEvent: MessageEvent<TextMessage>) {
        dialogueReply(textMessageEvent: textMessageEvent)
    }
    
    /// ImageMessageを受診した際の処理
    ///
    /// - Parameter imageMessageEvent: MessageEvent<ImageMessage>
    private func handle(imageMessageEvent: MessageEvent<ImageMessage>) {
        storeContent(messageEvent: imageMessageEvent)
    }
    
    
    
}
