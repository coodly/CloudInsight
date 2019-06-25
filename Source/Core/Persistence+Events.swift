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
import CoreDataPersistence
import CoreData

extension NSManagedObjectContext {
    internal func eventsNeedingPush() -> [Event] {
        return fetch(predicate: .needsSync)
    }
    
    internal func remove(events named: [String]) {
        let predicate = NSPredicate(format: "recordName IN %@", named)
        let removed: [Event] = fetch(predicate: predicate)
        Logging.log("Remove \(removed.count) events")
        delete(objects: removed)
    }

    internal func markFailure(on events: [String]) {
        let predicate = NSPredicate(format: "recordName IN %@", events)
        let failed: [Event] = fetch(predicate: predicate)
        failed.forEach({ $0.markSyncFailed() })
    }
}
