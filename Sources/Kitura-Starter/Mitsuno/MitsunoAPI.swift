//
//  MitsunoAPI.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/02/19.
//
//

import Foundation

public final class MitsunoAPI {}

public protocol MitsunoRequest: RequestProtocol {}

public extension MitsunoRequest {
    
    public var baseURL: URL {
        return URL(string: "https://tklinebotapi.mybluemix.net")!
    }
    
}
