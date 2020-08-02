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

extension Cloud {
    internal struct Event: RemoteRecord {
        static var recordType: String {
            "Event"
        }
        
        var recordName: String?
        var proposedName: String?
        var recordChangeTag: String?
        
        var time: Date?
        
        mutating func loadFields(from record: Record) -> Bool {
            time = record.time
            
            return true
        }
    }
}
