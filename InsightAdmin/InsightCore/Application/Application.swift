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
import CloudInsight
import CloudKit

public class Application {
    public static let shared = Application()
    
    private lazy var reporting = Insight.reporting(on: CKContainer(identifier: "iCloud.com.coodly.insight"))

    private init() {
        Log.enable()
    }
    
    public func initialize(completion: @escaping (() -> Void)) {
        reporting.load(completion: completion)
    }
    
    public func applicationsList() -> FetchedObjectsViewModel<CloudInsight.Application> {
        return FetchedObjectsViewModel(controller: reporting.fetchedControllerForApplications())
    }
}
