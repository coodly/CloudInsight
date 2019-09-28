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
import SWLogger
import CloudInsight

internal class Log {
    internal static func enable() {
        SWLogger.Log.level = .debug
        SWLogger.Log.add(output: ConsoleOutput())
        SWLogger.Log.add(output: FileOutput())
        
        CloudInsight.Logging.set(logger: InsightLogger())
    }
}


private class InsightLogger: CloudInsight.Logger {
    private lazy var log = SWLogger.Logging(name: "Insight")
    
    func log<T>(_ object: T, file: String, function: String, line: Int) {
        log.debug(object, file: file, function: function, line: line)
    }
}


