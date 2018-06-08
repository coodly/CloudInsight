/*
 * Copyright 2018 Coodly LLC
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
 */

import Foundation
import CloudKit
import CoreDataPersistence

internal protocol Injector {
    func inject(into object: AnyObject)
}

internal extension Injector {
    func inject(into object: AnyObject) {
        Injection.shared.inject(into: object)
    }
}

internal class Injection {
    internal static let shared = Injection()
    
    internal var container: CKContainer?
    
    internal lazy var persistence: CorePersistence = {
        let frameworkBundle = Bundle(for: Insight.self)
        let modelBundleURL = frameworkBundle.url(forResource: "CloudInsight", withExtension: "bundle")!
        let modelBundle = Bundle(url: modelBundleURL)!
        
        return CorePersistence(modelName: "CloudInsight", identifier: "com.coodly.insight", bundle: modelBundle, in: .cachesDirectory, wipeOnConflict: true)
    }()
    
    fileprivate func inject(into object: AnyObject) {
        if var consumer = object as? ContainerConsumer {
            consumer.insightContainer = container!
        }
    }
}
