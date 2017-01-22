//
//  ReplyMessageRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation
import KituraRequest
import KituraNet

public extension LineAPI {
    
    /// https://devdocs.line.me/ja/#reply-message
    ///
    /// ユーザ、グループ、トークルームからのイベントに返信するAPIです
    /// Webhookで通知されたイベントの中で、返信可能なイベントにはreplyTokenが付与されています
    /// このトークンを指定することで、イベントの送信元にメッセージを返信することができます
    ///
    /// replyTokenは一定秒間以内に使用しないと無効になりますので、受信してから可能な限り速く返信してください
    /// 使用回数の上限は1トークンにつき１回までです
    public struct ReplyMessageRequest: LineRequest, CustomStringConvertible {
        
        /// Webhookで受信したreplyToken
        public let replyToken: String
        
        /// 送信するメッセージ（最大5件）
        public let messages: [SendableMessage]
        
        public var method: Request.Method {
            return .post
        }
        
        public var path: String {
            return "/message/reply"
        }
        
        public var parameters: Request.Parameters? {
            return [
                "replyToken": replyToken,
                "messages": messages.map{ $0.parameters }
            ]
        }
        
        public var encoding: Encoding {
            return JSONEncoding.default
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> EmptyResponse {
            return EmptyResponse()
        }
    }
    
}

/// 空のレスポンス
public struct EmptyResponse {}

/// 送信するメッセージの内容の種別
public enum SendMessageType: String {
    case text      = "text"
    case image     = "image"
    case video     = "video"
    case audio     = "audio"
    case location  = "location"
    case sticker   = "sticker"
    case imagemap  = "imagemap"
    case template  = "template"
                  
}

/// Line Messaging API で送信可能なオブジェクトに適用する
public protocol SendableMessage {
    
    var messageType: SendMessageType { get }
    
    var parameters: [String : Any] { get }
    
}


/// Textにはemoticonを含めることができます。emoticonはUnicodeで管理されていますので、文字コードを変換してご利用ください。
/// 右の例では文字コード（0x1000B2）を使用しています。ブラウザでは文字化けしていますが、LINE上では正常に表示することができます。
/// 送信できるemoticonは以下を参照ください。
/// https://devdocs.line.me/files/emoticon.pdf
public struct SendableText: SendableMessage {
    
    public let messageType = SendMessageType.text
    
    /// メッセージのテキスト（2000文字以内）
    public let text: String
    
    public var parameters: [String : Any] {
        return [
            "type" : messageType.rawValue,
            "text" : text
        ]
    }
    
}

/// イメージ送信用オブジェクト
public struct SendableImage: SendableMessage {
    
    public let messageType = SendMessageType.image
    
    /// 画像のURL (1000文字以内)
    ///  - HTTPS
    ///  - JPEG
    ///  - 縦横最大1024px
    ///  - 最大1MB
    public let originalContentUrl: URL
    
    /// プレビュー画像のURL (1000文字以内)
    ///  - HTTPS
    ///  - JPEG
    ///  - 縦横最大240px
    ///  - 最大1MB
    public let previewImageUrl: URL
    
    public var parameters: [String : Any] {
        return [
            "type"               : messageType.rawValue,
            "originalContentUrl" : originalContentUrl.absoluteString,
            "previewImageUrl"    : previewImageUrl.absoluteString
        ]
    }
    
}

/// 動画送信用オブジェクト
public struct SendableVideo: SendableMessage {
    
    public let messageType = SendMessageType.video
    
    /// 動画ファイルのURL (1000文字以内)
    ///  - HTTPS
    ///  - mp4
    ///  - 長さ1分以下
    ///  - 最大10MB
    public let originalContentUrl: URL
    
    /// プレビュー画像のURL (1000文字以内)
    ///  - HTTPS
    ///  - JPEG
    ///  - 縦横最大240px
    ///  - 最大1MB
    public let previewImageUrl: URL
    
    public var parameters: [String : Any] {
        return [
            "type"               : messageType.rawValue,
            "originalContentUrl" : originalContentUrl.absoluteString,
            "previewImageUrl"    : previewImageUrl.absoluteString
        ]
    }
    
}

/// 音声ファイル送信用オブジェクト
public struct SendableAudio: SendableMessage {
    
    public let messageType = SendMessageType.audio
    
    /// 音声ファイルのURL (1000文字以内)
    ///  - HTTPS
    ///  - m4a
    ///  - 長さ1分以下
    ///  - 最大10MB
    public let originalContentUrl: URL
    
    /// 音声ファイルの時間長さ(ミリ秒)
    public let duration: Int
    
    public var parameters: [String : Any] {
        return [
            "type"               : messageType.rawValue,
            "originalContentUrl" : originalContentUrl.absoluteString,
            "duration"           : duration
        ]
    }
    
}

/// 位置情報送信用オブジェクト
public struct SendableLocation: SendableMessage {
    
    public let messageType = SendMessageType.location
    
    /// タイトル（100文字以内）
    public let title: String
    
    /// 住所（100文字以内）
    public let address: String
    
    /// 緯度
    public let latitude: Double
    
    /// 軽度
    public let longitude: Double
    
    public var parameters: [String : Any] {
        return [
            "type"      : messageType.rawValue,
            "title"     : title,
            "address"   : address,
            "latitude"  : latitude,
            "longitude" : longitude
        ]
    }
    
}

/// ステッカー送信用オブジェクト
public struct SendableSticker: SendableMessage {
    
    public let messageType = SendMessageType.sticker
    
    /// パッケージ識別子
    public let packageId: String
    
    /// Sticker識別子
    public let stickerId: String
    
    public var parameters: [String : Any] {
        return [
            "type"      : messageType.rawValue,
            "packageId" : packageId,
            "stickerId" : stickerId
        ]
    }
    
}

/// Imagemapはリンク付きの画像コンテンツです。画像全体を１つのリンクとしたり
/// 画像の複数の領域に異なるリンクURLを指定することもできます
public struct SendableImagemap: SendableMessage {
    
    public let messageType = SendMessageType.imagemap
    
    /// Imagemapに使用する画像のBaseURL（1000文字以内）
    /// BaseURLの末尾にクライアントが要求する解像度を横幅サイズ(px)で付与したURLでダウンロードできるようにしておく必要があります
    ///  - クライアント端末から要求される横幅サイズ: 1040, 700, 460, 300, 240 (px)
    ///  - HTTPS
    ///  - JPEG または PNG
    ///  - 最大1MB
    public let baseUrl: URL
    
    /// 代替テキスト（400文字以内）
    public let altText: String
    
    /// 基本比率サイズの幅（1040固定）
    public let baseWidth = 1040
    
    /// 基本比率サイズの高さ（幅を1040としたときの高さを指定してください）
    public let baseHeight: Int
    
    public var parameters: [String : Any] {
        return [
            "baseUrl"      : baseUrl.absoluteString,
            "altText" : altText,
            "baseSize" : [
                "width" : baseWidth,
                "height" : baseHeight
            ]
        ]
    }
}

