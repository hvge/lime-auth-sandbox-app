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
import PowerAuth2

class TemporaryActivationData {
	
    let activationCode: String
	let password: String
	let allowBiometry: Bool
    
	init(activationCode: String, password: String, allowBiometry: Bool) {
		self.activationCode = activationCode
		self.password = password
		self.allowBiometry = allowBiometry
	}
    
    var onSuccess: (()->Void)?
    var onFailure: (()->Void)?
}

protocol TemporaryActivationDataConsumer {
	var activationData: TemporaryActivationData? { get set }
}

class ActivateViewController: UIViewController {

	@IBOutlet weak var activationCodeTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var allowBiometrySwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.allowBiometrySwitch.isEnabled = PA2Keychain.canUseBiometricAuthentication
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activationCodeTextField.text = ""
    }
	

	@IBAction func activationAction(_ sender: Any) {
		guard let activationCode = activationCodeTextField.text else {
			let alert = UIAlertController(title: "Error", message: "Please enter activation code.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		guard let password = passwordTextField.text else {
			let alert = UIAlertController(title: "Error", message: "Please enter password.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		if !PA2OtpUtil.validateActivationCode(activationCode) {
			let alert = UIAlertController(title: "Error", message: "Activation code is not valid.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
            return
		}
        if password.count < 4 {
            let alert = UIAlertController(title: "Error", message: "Password is too short.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Create TemporaryActivationData object
        let activationData = TemporaryActivationData(activationCode: activationCode, password: password, allowBiometry: allowBiometrySwitch.isOn)
        activationData.onFailure = {
            self.navigationController?.popToViewController(self, animated: true)
        }
        activationData.onSuccess = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        // Switch screen
		self.performSegue(withIdentifier: "doActivation", sender: activationData)
	}
	
	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var activationDataConsumer = segue.destination as? TemporaryActivationDataConsumer
		activationDataConsumer?.activationData = sender as? TemporaryActivationData
	}

}
