//
//  GitHubAPI.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/01/22.
//
//

import Foundation

public final class GitHubAPI {}

public protocol GitHubRequest: RequestProtocol {}

public extension GitHubRequest {
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var headerFields: [String: String] {
        return [
            "Accept" : "application/vnd.github.v3+json",
            "Authorization" : "token \(Environment.get(.githubAccessToken))"
        ]
    }
}
