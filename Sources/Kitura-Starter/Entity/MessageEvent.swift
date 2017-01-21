//
//  MessageEvent.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import SwiftyJSON


/// メッセージが送信されたことを示すEventObjectです
/// このイベントは返信可能です
public struct MessageEvent<T: MessageProtocol>: LineWookEvent, Replyable {
    
    public let replyToken: String
    
    public let timestamp: Int
    
    public let source: EventSource
    
    public let messageType: T
    
    public init(json: JSON) {
        self.replyToken  = json["replyToken"].stringValue
        self.timestamp   = json["timestamp"].intValue
        self.source      = EventSource(json: json["source"])
        self.messageType = T(json: json["message"])
    }
    
}

public enum MessageType: String {
    case text     = "text"
    case image    = "image"
    case video    = "video"
    case audio    = "audio"
    case location = "location"
    case sticker  = "sticker"
}                  

public protocol MessageProtocol {
    
    /// メッセージ識別子
    var id: String { get }
    
    init(json: JSON)
}

/// イベント送信元から送信されたテキストを表すMessage Objectです
public struct TextMessage: MessageProtocol {

    public let id: String
    
    /// メッセージのテキスト
    public let text: String
    
    public init(json: JSON) {
        self.id   = json["id"].stringValue
        self.text = json["text"].stringValue
    }
    
}

/// イベント送信元から送信された画像を表すMessage Objectです
/// Get Content APIにより画像バイナリデータを取得できます
public struct ImageMessage: MessageProtocol {
    
    public let id: String
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
    }
    
}

/// イベント送信元から送信された動画を表すMessage Objectです
/// Get Content APIにより動画バイナリデータを取得できます
public struct VideoMessage: MessageProtocol {
    
    public let id: String
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
    }
    
}

/// イベント送信元から送信された音声を表すMessage Objectです
/// Get Content APIにより音声バイナリデータを取得できます
public struct AudioMessage: MessageProtocol {
    
    public let id: String
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
    }
    
}

/// イベント送信元から送信された位置情報を表すmessage objectです
public struct LocationMessage: MessageProtocol {
    
    public let id: String
    
    /// タイトル
    public let title: String
    
    /// 住所
    public let address: String
    
    /// 緯度
    public let latitude: Double
    
    /// 軽度
    public let longitude: Double
    
    public init(json: JSON) {
        self.id         = json["id"].stringValue
        self.title      = json["title"].stringValue
        self.address    = json["address"].stringValue
        self.latitude   = json["latitude"].doubleValue
        self.longitude  = json["longitude"].doubleValue
    }
    
}

/// イベント送信元から送信されたStickerを表すMessage Objectです
public struct StickerMessage: MessageProtocol {
    
    public let id: String
    
    /// パッケージ識別子
    public let packageId: String
    
    /// Sticker識別子
    public let stickerId: String
    
    public init(json: JSON) {
        self.id        = json["id"].stringValue
        self.packageId = json["packageId"].stringValue
        self.stickerId = json["stickerId"].stringValue
    }
    
}
