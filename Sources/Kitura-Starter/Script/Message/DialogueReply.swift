//
//  DialogueReply.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/24.
//
//

import Foundation
import LoggerAPI
import then

/// 対話APIの結果を返信する
///
/// - Parameter textMessageEvent: MessageEvent<TextMessage>
func dialogueReply(textMessageEvent: MessageEvent<TextMessage>) {
    
    let dialogueRequest = DocomoAPI.DialogueRequest(utt: textMessageEvent.messageType.text)
    
    let sendReply: (_ dialogueResponse: DocomoAPI.DialogueResponse) -> Promise<EmptyResponse> = {
        let replyMessage = SendableText(text: $0.utt ?? "")
        let replyRequest = LineAPI.ReplyMessageRequest(
            replyToken: textMessageEvent.replyToken,
            messages: [replyMessage])
        return WebAPIClient().send(replyRequest)
    }
    
    WebAPIClient()
        .send(dialogueRequest)
        .then(sendReply)
        .onError(Log.printError)
        .finally{}
    
}
