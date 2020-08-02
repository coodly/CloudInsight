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

import ArgumentParser
import TalkToCloud
import SWLogger
import Foundation

class CloudLogger: TalkToCloud.Logger {
    func error<T>(_ object: T, file: String, function: String, line: Int) {
        Log.error(object, file: file, function: function, line: line)
    }
    
    func verbose<T>(_ object: T, file: String, function: String, line: Int) {
        Log.verbose(object, file: file, function: function, line: line)
    }
    
    func log<T>(_ object: T, file: String, function: String, line: Int) {
        Log.debug(object, file: file, function: function, line: line)
    }
}

class Fetch: TalkToCloud.NetworkFetch {
    func fetch(_ request: URLRequest, completion: NetworkFetchClosure) {
        URLSession.shared.synchronousDataWithRequest(request: request, completionHandler: completion)
    }
}

Log.add(output: ConsoleOutput())
Log.level = .debug

Logging.set(logger: CloudLogger())

struct Command: ParsableCommand {
    @Flag(help: "Run in development env")
    var development: Bool = false

    @Flag(help: "Run in production env")
    var production: Bool = false

    @Option(name: .shortAndLong, help: "Days to keep")
    var days: Int

    func run() throws {
        let fetch = Fetch()
        
        let config = Configuration(containerId: "com.coodly.moviez")
        let container: CloudContainer
        if development {
            container = config.developmentContainer(with: fetch)
        } else if production {
            container = config.productionContainer(with: fetch)
        } else {
            fatalError("No environment selected")
        }
    }
}

Command.main()
