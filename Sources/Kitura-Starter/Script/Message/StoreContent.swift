//
//  StoreContent.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/02/04.
//
//

import Foundation
import LoggerAPI
import BluemixObjectStorage
import then

/// ユーザから送信された画像、動画、音声をObject Storageに保存する
///
/// - Parameter textMessageEvent: テキストメッセージイベント
func storeContent<T: MessageProtocol>(messageEvent: MessageEvent<T>) {
    
    switch messageEvent.messageType.type {
    case .image, .audio, .video: break
    default:                     return
    }
    
    let getContentRequest = LineAPI.GetContentRequest(messageId: messageEvent.messageType.id)
    
    let storeContent: (_ contentResponse: LineAPI.ContentResponse) -> Promise<ObjectStorageObject> = { contentResponse in
        let storage = ObjectStorageManager.shared
        return storage.connect()
            .then{ _ in
                storage.retrieveContainer(with: messageEvent.source.id, forceCreate: true)
            }
            .then {
                storage.storeObject(to: $0, name: contentResponse.suggestedFileName, data: contentResponse.data)
            }
    }
    
    let sendReply: (_ savedObject: ObjectStorageObject) -> Promise<EmptyResponse> = { savedObject in
        let text = "\(savedObject.name)として保存されました"
        let replyMessage = SendableText(text: text)
        let replyRequest = LineAPI.ReplyMessageRequest(
            replyToken: messageEvent.replyToken,
            messages: [replyMessage])
        return WebAPIClient().send(replyRequest)
    }
    
    WebAPIClient()
        .send(getContentRequest)
        .then(storeContent)
        .then(sendReply)
        .onError(Log.printError)
        .finally{}
    
}
