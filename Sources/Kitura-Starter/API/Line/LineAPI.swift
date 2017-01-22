//
//  LineRequest.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation

public final class LineAPI {}

public protocol LineRequest: RequestProtocol {}

public extension LineRequest {
    
    public var baseURL: URL {
        return URL(string: "https://api.line.me/v2/bot")!
    }
    
    public var headerFields: [String: String] {
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(Environment.get(.lineAccessToken))"
        ]
    }
}
