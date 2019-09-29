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

import CloudKit
import CoreData
import CoreDataPersistence

public protocol InsightReporting {
    func load(completion: @escaping (() -> Void))
    func fetchedControllerForApplications() -> NSFetchedResultsController<Application>
}

extension Insight: InsightReporting {
    public static func reporting(on container: CKContainer) -> InsightReporting {
        Logging.log("Reportin on \(container)")
        return Insight(container: container, persistentData: true)
    }
    
    public func load(completion: @escaping (() -> Void)) {
        inject(into: self)
        
        let loadPersistence = LoadPersistenceOperation()
        let callback: ((Result<LoadPersistenceOperation, Error>) -> Void) = {
            _ in
            
            completion()
        }
        loadPersistence.onCompletion(callback: callback)
        
        let updates = BlockOperation(block: fetchUpdates)
        updates.addDependency(loadPersistence)
        
        inject(into: loadPersistence)
        queue.addOperations([loadPersistence, updates], waitUntilFinished: false)
    }
    
    private func fetchUpdates() {
        var operations = [Operation]()
        operations.add(operation: PullDevicesOperation())
        operations.add(operation: PullEventsOperation())
        
        operations.forEach({ inject(into: $0) })
        queue.addOperations(operations, waitUntilFinished: false)
    }
    
    public func fetchedControllerForApplications() -> NSFetchedResultsController<Application> {
        return persistence.mainContext.fetchedControllerForApplications()        
    }
}
