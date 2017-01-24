//
//  DialogueRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/23.
//
//

import Foundation
import KituraRequest
import KituraNet
import SwiftyJSON

public extension DocomoAPI {
    
    public struct DialogueRequest: DocomoRequest {
        
        // MARK: Types
        
        public enum Sex: String {
            case male   = "男"
            case female = "女"
        }
        
        public enum BloodType: String {
            case A  = "A"
            case B  = "B"
            case AB = "AB"
            case O  = "D"
        }
        
        public enum Constellations: String {
            case aries = "牡羊座"
        }
        
        public enum Mode: String {
            case dialog = "dialog"
            case srtr   = "srtr"
        }
        
        public enum CharacterType: String {
            case kansai = "20"
            case baby   = "30"
        }
        
        
        public typealias Birthday = (year: Int, month: Int, day: Int)
        
        
        // MARK: Properties
        
        /// ユーザの発話を指定(255文字以下)
        /// サンプル値) こんにちは
        public var utt: String
        
        /// コンテキストIDを指定(255文字以下)
        /// サンプル値) aaabbbccc111222333
        /// ※会話(しりとり)を継続する場合は、レスポンスボディのcontextの値を指定する
        public var context: String?
        
        /// ユーザのニックネームを指定(全角10文字(半角10文字)以下)
        /// サンプル値) 光
        public var nickname: String?
        
        /// ユーザのニックネームの読みを指定(全角20文字以下(カタカナのみ))
        /// サンプル値) ヒカリ
        public var nickname_y: String?
        
        /// ユーザのユーザの性別
        public var sex: Sex?
        
        /// ユーザの血液型
        public var bloodtype: BloodType?
        
        /// ユーザの誕生日
        public var birthday: Birthday?
        
        /// ユーザの年齢
        public var age: Int?
        
        /// ユーザの星座
        public var constellations: Constellations?
        
        /// https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_name=dialogue&p_name=api_1#tag01
        public var place: String?
        
        /// 対話のモードは、下記のいずれかを指定
        /// ※会話(しりとり)を継続する場合は、レスポンスボディのmodeの値を指定する
        public var mode: Mode = .dialog
        
        /// キャラクタ
        /// nilの場合はデフォルト
        public var characterType: CharacterType?
        
        
        // MARK: DocomoRequest
        
        public var method: Request.Method {
            return .post
        }
        
        public var path: String {
            return "/dialogue/v1/dialogue?APIKEY=\(Environment.get(.docomoAPIKey))"
        }
        
        public var encoding: Encoding {
            return JSONEncoding.default
        }
        
        public var parameters: Request.Parameters? {
            var p = [
                "utt" : utt,
                "mode" : mode.rawValue
            ]
            
            context.map{ p["context"] = $0 }
            nickname.map{ p["nickname"] = $0 }
            nickname_y.map{ p["nickname_y"] = $0 }
            sex.map{ p["sex"] = $0.rawValue }
            bloodtype.map{ p["bloodtype"] = $0.rawValue }
            age.map{ p["age"] = "\($0)" }
            constellations.map{ p["constellations"] = $0.rawValue }
            place.map{ p["place"] = $0 }
            characterType.map{ p["t"] = $0.rawValue }
            
            return p
        }
        
        public func response(from data: Data, clientResponse: ClientResponse) throws -> DialogueResponse {
            let json = JSON(data: data)
            return DialogueResponse(json)
        }
        
        
        // MARK: Initializer
        
        public init(utt: String) {
            self.utt = utt
        }
        
    }
    
    
    public struct DialogueResponse: CustomStringConvertible {
        
        /// システムからの返答
        /// サンプル値) こんにちは光さん
        public let utt: String?
        
        /// 音読を間違えそうな漢字をカタカナにして返却
        /// 一般的な語についてはuttと同じ内容となる
        /// サンプル値) こんにちはヒカリさん
        public let yomi: String?
        
        /// 対話のモード
        /// ※会話(しりとり)を継続する場合は、この値をリクエストボディのmodeに指定する
        public let mode: DialogueRequest.Mode?
        
        /// ユーザとシステムの対話に対してサーバが付与した番号を返却
        /// サンプル値) 0
        public let da: String?
        
        /// 自動的にシステムより出力されるIDを返却
        /// サンプル値) aaabbbccc111222333
        /// ※会話(しりとり)を継続する場合は、この値をリクエストボディのcontextに指定する
        public let context: String?
        
        init(_ json: JSON) {
            self.utt     = json["utt"].string
            self.yomi    = json["yomi"].string
            self.mode    = json["mode"].string.flatMap { DialogueRequest.Mode(rawValue: $0) }
            self.da      = json["da"].string
            self.context = json["context"].string
        }
        
    }
    
}
