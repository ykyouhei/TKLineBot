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
import then

/// 対話APIの結果を返信する
///
/// - Parameter textMessageEvent: MessageEvent<TextMessage>
func dialogueReply(textMessageEvent: MessageEvent<TextMessage>) {
    
    let getProfileRequest = LineAPI.GetProfileRequest(userId: textMessageEvent.source.id)
    
    let sendDialogueRequest: (_ profile: LineAPI.Profile) -> Promise<DocomoAPI.DialogueResponse> = {
        var dialogueRequest = DocomoAPI.DialogueRequest(utt: textMessageEvent.messageType.text)
        dialogueRequest.nickname = $0.displayName
        return WebAPIClient().send(dialogueRequest)
    }
    
    let sendReply: (_ dialogueResponse: DocomoAPI.DialogueResponse) -> Promise<EmptyResponse> = {
        let replyMessage = SendableText(text: $0.utt ?? "")
        let replyRequest = LineAPI.ReplyMessageRequest(
            replyToken: textMessageEvent.replyToken,
            messages: [replyMessage])
        return WebAPIClient().send(replyRequest)
    }
    
    WebAPIClient()
        .send(getProfileRequest)
        .then(sendDialogueRequest)
        .then(sendReply)
        .onError(Log.printError)
        .finally{}
    
}
