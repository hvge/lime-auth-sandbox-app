//
// Copyright 2018 Lime - HighTech Solutions s.r.o.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//

import Foundation


class DebugConfig {
    static func loadDebugConfiguration(file: String = "Configuration") -> [String:[String:String]]? {
        #if DEBUG
            guard let configPath = Bundle.main.path(forResource: "DebugData/\(file)", ofType: "json") else {
                return nil
            }
            do {
                let configData = try Data(contentsOf: URL(fileURLWithPath: configPath), options: .alwaysMapped)
                let jsonRoot = try JSONSerialization.jsonObject(with: configData, options: .allowFragments)
                return jsonRoot as? [String: [String:String]]
            } catch let error {
                D.print("Could not load configuration file: \(error.localizedDescription)")
            }
        #endif
        return nil
    }
}

