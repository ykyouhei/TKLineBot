//
//  DocomoAPI.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/23.
//
//

import Foundation

public final class DocomoAPI {}

public protocol DocomoRequest: RequestProtocol {}

public extension DocomoRequest {
    
    public var baseURL: URL {
        return URL(string: "https://api.apigw.smt.docomo.ne.jp")!
    }
    
}
