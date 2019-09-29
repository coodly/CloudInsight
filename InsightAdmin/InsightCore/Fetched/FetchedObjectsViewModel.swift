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
import CoreData
import Combine

public class FetchedObjectsViewModel<ResultType: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    private let fetchedResultsController: NSFetchedResultsController<ResultType>
    
    @Published private var changedAt: Date?
    
    public var fetchedObjects: [ResultType] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    internal init(controller: NSFetchedResultsController<ResultType>) {
        self.fetchedResultsController = controller
                    
        super.init()
        
        controller.delegate = self
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changedAt = Date()
    }
}
