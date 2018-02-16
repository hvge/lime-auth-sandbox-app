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
		
		self.switchAppState()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
	}
	
	
	func switchAppState() {
		if LimeAuthSession.shared.hasValidActivation {
			self.performSegue(withIdentifier: "switchToStatusCheck", sender: nil)
		} else {
			self.performSegue(withIdentifier: "switchToActivation", sender: nil)
		}
	}

}

