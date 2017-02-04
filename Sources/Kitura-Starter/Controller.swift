/**
* Copyright IBM Corporation 2016
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

import Kitura
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv
import Regex
import BluemixObjectStorage

/// WebServerのRoutingを行う
public class Controller {
    
    let router: Router
    let appEnv: AppEnv
    
    var port: Int {
        get { return appEnv.port }
    }
    
    var url: String {
        get { return appEnv.url }
    }
    
    init() throws {
        appEnv = try CloudFoundryEnv.getAppEnv()
        
        // All web apps need a Router instance to define routes
        router = Router()
        
        router.post("/line/webhook", middleware: LineBotServer())
        
        setupAPISampleRouting()
        
        // Object Storeのテスト
        let store = ObjectStorageManager.shared
        store.connect()
            .then(store.retrieveContainer(with: .tkbot))
            .then { container in
                store.retrieveObject(for: container, name: "testData.txt")
            }
            .then{ object in
            }
            .finally{}
    }
    
}


// MARK: - API Sample

extension Controller {
    
    fileprivate func setupAPISampleRouting() {
        
        func send<T: RequestProtocol>(request: T, response: RouterResponse) {
            WebAPIClient()
                .send(request)
                .then   { try? response.send("\($0)").send(status: .OK).end() }
                .onError{ try? response.send("\($0)").send(status: .internalServerError).end() }
                .finally{}
        }
        
        router.get("/api/docomo/dialogue") { request, response, completion in
            let q = request.queryParameters
            let r = DocomoAPI.DialogueRequest(utt: q["utt"] ?? "")
            send(request: r, response: response)
        }
        
        router.get("/api/docomo/knowledgeQA") { request, response, completion in
            let q = request.queryParameters
            let r = DocomoAPI.KnowledgeQARequest(query: q["query"] ?? "")
            send(request: r, response: response)
        }
        
    }
    
}
