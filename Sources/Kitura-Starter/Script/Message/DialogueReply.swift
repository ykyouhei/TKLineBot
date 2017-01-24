//
//  DialogueReply.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/24.
//
//

import Foundation
import Result
import LoggerAPI

/// 対話APIの結果を返信する
///
/// - Parameter textMessageEvent: MessageEvent<TextMessage>
func dialogueReply(textMessageEvent: MessageEvent<TextMessage>) {
    
    let dialogueRequest = DocomoAPI.DialogueRequest(utt: textMessageEvent.messageType.text)
    
    WebAPIClient().send(request: dialogueRequest) { result in
        switch result {
        case .success(let dialogue):
            let replyMessage = SendableText(text: dialogue.utt ?? "")
        
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
            
        case .failure(let error):
            Log.error("\(error)")
        }
    }
    
    
    
    
    
}
