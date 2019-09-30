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
import Combine

public class ApplicationSummaryViewModel: ObservableObject {
    public let identifier: String
    @Published public var formattedUsersToday: String = ""
    @Published public var formattedSessionsToday: String = ""
    
    private var usersSubscription: AnyCancellable?
    private var sessionSubscription: AnyCancellable?
    
    public init(app: Application) {
        identifier = app.identifier
        
        formattedUsersToday = String(describing: app.newUsersToday)
        formattedSessionsToday = String(describing: app.sessions)
        
        usersSubscription = app.publisher(for: \.newUsersToday).sink(receiveValue: { self.formattedUsersToday = String(describing: $0) })
        sessionSubscription = app.publisher(for: \.sessions).sink(receiveValue: { self.formattedSessionsToday = String(describing: $0) })
    }
}
