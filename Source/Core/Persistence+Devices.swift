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
import CoreDataPersistence

extension NSPredicate {
    private static let statusNeedsSync = NSPredicate(format: "syncStatus.syncNeeded = YES")
    private static let statusNotFailed = NSPredicate(format: "syncStatus.syncFailed = NO")
    internal static let needsSync = NSCompoundPredicate(andPredicateWithSubpredicates: [.statusNeedsSync, .statusNotFailed])
}

extension NSManagedObjectContext {
    internal func device(with id: String) -> Device? {
        return fetchEntity(where: "recordName", hasValue: id)
    }
    
    internal func createDevice(with id: String) -> Device {
        let device: Device = insertEntity()
        device.recordName = id
        return device
    }
    
    internal func refresh(device: Cloud.Device) {
        let saved: Device = fetchEntity(where: "recordName", hasValue: device.recordName!) ?? insertEntity()
        
        saved.recordName = device.recordName
        saved.recordData = device.recordData
        saved.model = device.model
        saved.osVersion = device.osVersion
    }
    
    internal func devicesNeedingPush() -> [Device] {
        return fetch(predicate: .needsSync)
    }
    
    internal func devices(with names: [String]) -> [Device] {
        let predicate = NSPredicate(format: "recordName IN %@", names)
        return fetch(predicate: predicate)
    }
    
    internal func load(devices: [Cloud.Device]) {
        let appIdentifiers = Set(devices.compactMap({ $0.appIdentifier }))
        let applications = self.applications(with: appIdentifiers)
        
        let existingDevices = self.devices(with: devices.compactMap({ $0.recordName }))
        for device in devices {
            let saved: Device
            if let existing = existingDevices.first(where: { $0.recordName == device.recordName }) {
                saved = existing
            } else {
                saved = insertEntity()
                saved.recordName = device.recordName
            }
            
            saved.application = applications.first(where: { $0.identifier == device.appIdentifier })
            saved.model = device.model
            saved.osVersion = device.osVersion
        }
    }
}
