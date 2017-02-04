//
//  ObjectStroageManager.swift
//  Kitura-Starter
//
//  Created by kyo__hei on 2017/02/04.
//
//

import Foundation
import BluemixObjectStorage
import LoggerAPI
import then


/// Bluemix Object Strageを管理するクラス
internal final class ObjectStorageManager {
    
    // MARK: Types
    
    enum ContainerName: String {
        case tkbot = "tkbot"
    }
    
    static let shared = ObjectStorageManager()
    
    private let objectStorage: ObjectStorage
    
    private init() {
        self.objectStorage = ObjectStorage(projectId: Environment.get(.objectstorageProjectId))
    }
    
    
    /// ObjectStoreへ接続する
    ///
    /// - Returns: Promise<Bool>
    func connect() -> Promise<Bool> {
        return Promise { resolve, reject in
            self.objectStorage.connect(
                userId: Environment.get(.objectstorageUserId),
                password: Environment.get(.objectstoragePassword),
                region: ObjectStorage.REGION_DALLAS,
                completionHandler: { error in
                    if let error = error {
                        Log.error("[Feilure] connect object strage. \(error)")
                        reject(error)
                    } else {
                        Log.info("[Success] connect object strage.")
                        resolve(true)
                    }
            })
        }
    }
    
    
    // MARK: Container
    
    /// コンテナー情報を取得する
    ///
    /// - Parameter name: コンテナ名
    /// - Returns:  Promise<ObjectStorageContainer>
    func retrieveContainer(with name: ContainerName) -> Promise<ObjectStorageContainer> {
        return Promise { resolve, reject in
            self.objectStorage.retrieveContainer(name: name.rawValue) { error, container in
                if let error = error {
                    Log.error("retrieveContainer error :: \(error)")
                    reject(error)
                } else if let container = container {
                    Log.info("retrieveContainer success :: \(container.name)")
                    resolve(container)
                } else {
                    reject(ServerError.emptyResponse)
                }
            }
        }
    }
    
    /// オブジェクトを保存する
    ///
    /// - Parameters:
    ///   - container: 保存先のコンテナー
    ///   - name: オブジェクト名
    ///   - data: バイナリデータ
    /// - Returns: Promise<ObjectStorageObject>
    func storeObject(to container: ObjectStorageContainer, name: String, data: Data) -> Promise<ObjectStorageObject> {
        return Promise { resolve, reject in
            container.storeObject(name: name, data: data) { error, object in
                if let error = error {
                    Log.error("storeObject error :: \(error)")
                    reject(error)
                } else if let object = object {
                    Log.info("storeObject success :: \(object)")
                    resolve(object)
                } else {
                    reject(ServerError.emptyResponse)
                }
            }
        }
    }
    
    /// オブジェクトを取得する
    ///
    /// - Parameters:
    ///   - container: 取得元のコンテナ
    ///   - name:      オブジェクト名
    /// - Returns: Promise<ObjectStorageObject>
    func retrieveObject(for container: ObjectStorageContainer, name: String) -> Promise<ObjectStorageObject> {
        return Promise { resolve, reject in
            container.retrieveObject(name: name) { error, object in
                if let error = error {
                    Log.error("retrieveObject error :: \(error)")
                    reject(error)
                } else if let object = object {
                    Log.info("retrieveObject success :: \(object)")
                    resolve(object)
                } else {
                    reject(ServerError.emptyResponse)
                }
            }
        }
    }
    
    
}
