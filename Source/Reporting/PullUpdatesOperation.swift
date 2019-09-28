/*
* Copyright 2019 Coodly LLC
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
import Puff
import CoreDataPersistence
import CoreData

private typealias Dependencies = ContainerConsumer & PersistenceConsumer

internal class PullUpdatesOperation<T: RemoteRecord & Timestamped>: CloudKitRequest<T>, Dependencies {
    var insightContainer: CKContainer! {
        didSet {
            self.container = insightContainer
        }
    }
    var persistence: CorePersistence!
    
    override func performRequest() {
        persistence.performInBackground() {
            context in
            
            Logging.log("Pull updates for \(String(describing: T.self))")
            let lastKnown = context.lastKnownTime(for: T.self)
            Logging.log("Pull updates after \(lastKnown)")

            let sort = NSSortDescriptor(key: "modificationDate", ascending: true)
            let predicate = NSPredicate(format: "modificationDate >= %@", lastKnown as NSDate)
            
            self.fetch(predicate: predicate, sort: [sort], pullAll: true, inDatabase: .public)
        }
    }
    
    override func handle(result: CloudResult<T>, completion: @escaping () -> ()) {
        let save: ContextClosure = {
            context in
            
            if let error = result.error {
                Logging.log("Load error: \(error)")
            } else {
                self.load(records: result.records, into: context)
                
                guard let lastKnown = result.records.last?.modifiedAt else {
                    return
                }
                
                Logging.log("Mark last known to \(lastKnown)")
                context.markLastKnow(time: lastKnown, for: T.self)
            }
        }
        
        persistence.performInBackground(task: save, completion: completion)
    }
    
    internal func load(records: [T], into context: NSManagedObjectContext) {
        Logging.log("Load \(records.count) records")
    }
}
