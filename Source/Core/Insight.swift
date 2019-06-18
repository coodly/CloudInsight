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

import CloudKit

private typealias Dependencies = InsightQueueConsumer

public class Insight: Injector, Dependencies {
    var queue: OperationQueue!
    
    public init(container: CKContainer) {
        Logging.log("Start with \(String(describing: container.containerIdentifier))")
        Injection.shared.container = container
    }
    
    public func initialize() {
        inject(into: self)
        
        let op = LoadPersistenceOperation()
        inject(into: op)
        
        queue.addOperation(op)
    }
}
