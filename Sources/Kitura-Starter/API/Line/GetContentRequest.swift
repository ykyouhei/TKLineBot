//
//  GetContentRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/02/04.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension LineAPI {
    
    /// https://devdocs.line.me/ja/#content
    ///
    /// ユーザから送信された画像、動画、音声にアクセスする
    /// 成功時はstatus code 200と共にコンテンツのバイナリデータを返します
    /// コンテンツはメッセージが送信されてからある期間経過した時点で自動的に削除されます。保存される期間についての保証はありません
    public struct GetContentRequest: LineRequest, CustomStringConvertible {
        
        /// メッセージの識別子
        public let messageId: String
        
        
        public var method: Request.Method {
            return .get
        }
        
        public var path: String {
            return "/message/\(messageId)/content"
        }
        
        public var encoding: Encoding {
            return URLEncoding.default
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> ContentResponse {
            let contentLength = clientResponse.headers["Content-Length"]?.first.flatMap{ Int($0) } ?? 0
            let contentType   = clientResponse.headers["Content-Type"]?.first ?? ""
            let content = ContentResponse(messageId: messageId,
                                          data: data,
                                          contentLength: contentLength,
                                          contentType: contentType)
            return content
        }
    }
    
    
    public struct ContentResponse: CustomStringConvertible {
        
        let messageId: String
        
        let data: Data
        
        let contentLength: Int
        
        let contentType: String
        
        var suggestedFileName: String {
            let ext = MimeType.fileExtension(forMimeType: contentType) ?? "data"
            return "\(messageId).\(ext)"
        }
        
    }
    
}
