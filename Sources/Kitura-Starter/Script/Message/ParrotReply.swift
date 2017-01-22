//
//  ParrotReply.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import LoggerAPI

/// 受け取ったテキストメッセージをそのまま返す
///
/// - Parameter textMessageEvent: テキストメッセージイベント
func parrotReply(textMessageEvent: MessageEvent<TextMessage>) {
    
    let replyMessage = SendableText(text: textMessageEvent.messageType.text)
    
    let replyRequest = LineAPI.ReplyMessageRequest(
        replyToken: textMessageEvent.replyToken,
        messages: [replyMessage])
    
    WebAPIClient().send(request: replyRequest) { result in
        switch result {
        case .success:
            Log.debug("Success: \(replyRequest)")
            
        case .failure(let error):
            Log.error("Error: \(error)")
        }
    }
    
}
