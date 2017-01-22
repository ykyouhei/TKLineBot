//
//  LineWookEvent.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/21.
//
//

import Foundation
import SwiftyJSON

/// イベントの送信元
///
/// - user:  ユーザ
/// - group: グループ
/// - room:  ルーム
public enum EventSource {
    case user(userId: String)
    case group(groupId: String)
    case room(roomId: String)
    
    init(json: JSON) {
        let type = json["type"].stringValue
        switch type {
        case "user":  self = .user(userId: json["userId"].stringValue)
        case "group": self = .group(groupId: json["groupId"].stringValue)
        case "room":  self = .room(roomId: json["roomId"].stringValue)
        default:
            fatalError("未定義のEventSourceです\(type)")
        }
    }
}

public enum EventType: String {
    case message  = "message"
    case follow   = "follow"
    case unfollow = "unfollow"
    case join     = "join"
    case leave    = "leave"
    case postback = "postback"
    case beacon   = "beacon"
}                     

public protocol Replyable {
    
    /// 返信用トークン
    var replyToken: String { get }
    
}

public protocol LineWookEvent {
    
    /// イベントの時刻を表すミリ秒
    var timestamp: Int { get }
    
    /// イベントの送信元
    var source: EventSource { get }
    
}
