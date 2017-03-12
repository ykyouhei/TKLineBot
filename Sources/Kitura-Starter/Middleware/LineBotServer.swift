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
            
        default:
            break
        }
    }
    
    private func routeMessageEvent(eventJSON: JSON) {
        guard let messageTypeRaw = eventJSON["message"]["type"].string,
              let messageType    = MessageEventType(rawValue: messageTypeRaw) else {
                return
        }
        
        Log.info("========= MessageType is \(messageType) ==========")
        Log.debug("\(eventJSON)")
        
        switch messageType {
        case .text:
            let textMessageEvent = MessageEvent<TextMessage>(json: eventJSON)
            let text             = textMessageEvent.messageType.text
            
            switch text {
            case ".+[?|？]$".r:
                knowledgeQAReply(textMessageEvent: textMessageEvent)
            default:
                dialogueReply(textMessageEvent: textMessageEvent)
            }
           
        case .image:
            let imageMessageEvent = MessageEvent<ImageMessage>(json: eventJSON)
            storeContent(messageEvent: imageMessageEvent)
            
        case .video:    break
        case .audio:    break
        case .location: break  
        case .sticker:  break
        }
    }
    
}
