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

import UIKit
import LimeAuth

class MainViewController: EmbeddingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: LimeAuthSession.didRemoveActivation, object: nil, queue: .main) { (notification) in
            self.switchAppState(forceTest: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchAppState()
    }

    private var lastHasValidActivation: Bool?
    
    func switchAppState(forceTest: Bool = false) {
        let currentState = LimeAuthSession.shared.hasValidActivation
        if let lastState = lastHasValidActivation {
            if lastState == currentState && !forceTest {
                return
            }
        }
        lastHasValidActivation = currentState
        if currentState {
            self.performSegue(withIdentifier: "switchToStatusCheck", sender: nil)
        } else {
            self.performSegue(withIdentifier: "switchToActivation", sender: nil)
        }
    }

}

