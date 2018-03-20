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
import PowerAuth2

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var removeActivationButton: UIButton!
    @IBOutlet weak var removeLocalActivationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeActivation(_ sender: Any) {
        let auth = PowerAuthAuthentication()
        auth.usePassword = "1234"
        auth.usePossession = true
        disableButtons(disable: true)
        let _ = LimeAuthSession.shared.removeActivation(authentication: auth) { (error) in
            self.disableButtons(disable: false)
            if error != nil {
                LimeAuthSession.shared.removeActivationLocal()
            }
        }
    }
    
    @IBAction func removeLocalActivation(_ sender: Any) {
        LimeAuthSession.shared.removeActivationLocal()
    }
    
    private func disableButtons(disable: Bool) {
        loginButton.isEnabled = !disable
        removeActivationButton.isEnabled = !disable
        removeLocalActivationButton.isEnabled = !disable
    }

    private var authenticationUI: LimeAuthAuthenticationUI?
    
    @IBAction func loginAction(_ sender: Any) {
        
        let session = LimeAuthSession.shared
        let resourcesProvider = LimeAuthAuthenticationUI.defaultResourcesProvider()
        let credentialsProvider = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        
        // Creates repeatable operation, you need to implement execution in provided closure
        let operation = OnlineAuthenticationUIOperation(isSerialized: true) { (authentication, completionCallback) -> Operation? in
            let _ = session.powerAuth.validatePasswordCorrect(authentication.usePassword!) { (error) in
                if let error = error {
                    completionCallback(nil, LimeAuthError(error: error))
                } else {
                    completionCallback(nil, nil)
                }
            }
            return nil
        }
        
        var request = Authentication.UIRequest()
        request.tweaks.successAnimationDelay = 650
        //request.options.insert([.allowBiometryFactor, .askFirstForBiometryFactor])
        let authUI = LimeAuthAuthenticationUI(session: session, uiProvider: resourcesProvider, credentialsProvider: credentialsProvider, request: request, operation: operation) { (result, response, finalController) in
            self.authenticationUI = nil
            D.print("Operation result: \(result)")
            // dismiss UI
            finalController?.dismiss(animated: true, completion: nil)
			if result == .success {
				self.performSegue(withIdentifier: "goToSettings", sender: nil)
			}
        }
        self.authenticationUI = authUI
        // present UI
        authUI.present(to: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
