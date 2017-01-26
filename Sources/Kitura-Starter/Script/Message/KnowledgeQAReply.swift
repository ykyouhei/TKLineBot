//
//  KnowledgeQAReply.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/26.
//
//

import Foundation
import LoggerAPI
import then

/// 知識Q&Aの結果を返信する
///
/// - Parameter textMessageEvent: MessageEvent<TextMessage>
func knowledgeQAReply(textMessageEvent: MessageEvent<TextMessage>) {
    
    let knowledgeQARequest = DocomoAPI.KnowledgeQARequest(query: textMessageEvent.messageType.text)
    
    let sendReply: (_ knowledgeQAResponse: DocomoAPI.KnowledgeQAResponse) -> Promise<EmptyResponse> = {
        var text = [$0.message.forDisplay]
        if let link = $0.answers.first?.linkUrl {
            text.append(link.absoluteString)
        }
        
        let replyMessage = SendableText(text: text.joined(separator: "\n"))
        let replyRequest = LineAPI.ReplyMessageRequest(
            replyToken: textMessageEvent.replyToken,
            messages: [replyMessage])
        return WebAPIClient().send(replyRequest)
    }
    
    WebAPIClient()
        .send(knowledgeQARequest)
        .then(sendReply)
        .onError(Log.printError)
        .finally{}
    
}
