//
//  KnowledgeQARequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/26.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension DocomoAPI {
    
    /// https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_name=knowledge_qa&p_name=api_1#tag01
    ///
    /// 質問をテキストでインプットすると、回答を返却するAPIです
    /// 質問は話しかけるような自然な文章を入力できます。回答はズバリの回答候補をJSON形式で返却します
    public struct KnowledgeQARequest: DocomoRequest {
        
        /// 質問文を半角/全角2000文字以内で設定する
        let query: String

        // MARK: DocomoRequest
        
        public var method: Request.Method {
            return .get
        }
        
        public var path: String {
            return "/knowledgeQA/v1/ask"
        }
        
        public var encoding: Encoding {
            return URLEncoding.default
        }
        
        public var parameters: Request.Parameters? {
            return [
                "APIKEY": "\(Environment.get(.docomoAPIKey))",
                "q" : query
            ]
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> KnowledgeQAResponse {
            let json = JSON(data: data)
            return KnowledgeQAResponse(json: json)
        }
        
    }

}


public extension DocomoAPI {
    
    public struct KnowledgeQAResponse {
        
        /// 質問回答のレスポンスコード
        /// Sで始まる場合は正常回答、Eで始まる場合は回答が得られていないことを示す
        public enum Code: String {
            case S020000  = "S020000"  // 内部のDBからリストアップした回答
            case S020001  = "S020001"  // 知識Q&A APIが計算した回答
            case S020010  = "S020010"  // 外部サイトから抽出した回答候補
            case S020011  = "S020011"  // 外部サイトへのリンクを回答
            case E010000  = "E010000"  // 回答不能(パラメータ不備)
            case E020000  = "E020000"  // 回答不能(結果0件)
            case E099999  = "E099999"  // 回答不能(処理エラー)
            case unknown  = "UNKNOWN"  // 不明なコード
        }
        
        public struct Answer {
            public let rank: Int
            public let answerText: String
            public let linkText: String?
            public let linkUrl: URL?
            
            init(json: JSON) {
                self.rank       = Int(json["rank"].stringValue)!
                self.answerText = json["answerText"].stringValue
                self.linkText   = json["linkText"].string
                self.linkUrl    = json["linkUrl"].string.flatMap { URL(string: $0) }
            }
        }
        
        /// 質問回答のレスポンスコード
        public let code: Code
        
        /// ユーザに返却するメッセージに関する情報
        ///  - forDisplay: メッセージ表示用のテキスト
        ///  - forSpeech:  メッセージ読み上げ用のテキスト
        public let message: (forDisplay: String, forSpeech: String)
        
        /// answerオブジェクトのリストを返却(回答は最大5件)
        public let answers: [Answer]
        
        init(json: JSON) {
            self.code    = Code(rawValue: json["code"].stringValue) ?? .unknown
            self.message = (forDisplay: json["message"]["textForDisplay"].stringValue,
                            forSpeech:  json["message"]["textForSpeech"].stringValue)
            self.answers = json["answers"].arrayValue.map { Answer(json: $0) }
        }
        
    }
    
}
