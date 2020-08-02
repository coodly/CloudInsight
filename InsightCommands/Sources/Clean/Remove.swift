/*
* Copyright 2020 Coodly LLC
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
import TalkToCloud
import SWLogger

internal class Remove {
    private let daysToKeep: Int
    private let container: CloudContainer
    internal init(keep days: Int, container: CloudContainer) {
        self.daysToKeep = days
        self.container = container
    }
    
    internal func execute() {
        Log.debug("Keep \(daysToKeep) days")
        
        let removeBefore = Date().adding(days: -daysToKeep).startOfDay
        Log.debug("Remove everything before \(removeBefore)")
        
        let handler: ((CloudResult<Cloud.Event>) -> Void) = {
            result in
            
            if let error = result.error {
                Log.error("Fetch events error: \(error)")
            } else {
                Log.debug("Fetched \(result.records.count) events")
                self.remove(result.records, continuation: result.continuation)
            }
        }
        
        let filter = Filter.lt("time", removeBefore as AnyObject)
        let sort = Sort.ascending("time")
        container.fetch(desiredKeys: ["time"], filter: filter, sort: sort, in: .public, completion: handler)
    }
    
    private func remove(_ records: [Cloud.Event], continuation: (() -> Void)?) {
        guard records.count > 0 else {
            continuation?()
            return
        }
        
        Log.debug("Remove \(records.count) events")
        let handler: ((CloudResult<Cloud.Event>) -> Void) = {
            result in
            
            if let error = result.error {
                Log.error("Remove error \(error)")
            } else {
                Log.debug("Removed \(result.deleted.count) records")
                Log.debug("Removed up to \(records.last!.time!)")
                continuation?()
            }
        }
        
        container.delete(records: records, completion: handler)
    }
}
