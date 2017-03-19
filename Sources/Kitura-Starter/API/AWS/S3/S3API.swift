//
//  S3API.swift
//  Kitura-Starter
//
//  Created by 山口　恭兵 on 2017/03/19.
//
//

import Foundation
import S3SignerAWS

public final class S3API {}

public protocol S3Request: RequestProtocol {}

public extension S3Request {
    
    public var s3Signer: S3SignerAWS {
        return S3SignerAWS(accessKey: Environment.get(.s3AccessKey),
                           secretKey: Environment.get(.s3SecretKey),
                           region: .apNortheast1)
    }
    
    public var baseURL: URL {
        return URL(string: "https://tanaka-wedding.s3.amazonaws.com")!
    }
    
}
