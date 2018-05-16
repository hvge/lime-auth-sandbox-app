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
        let resourcesProvider = LimeAuthAuthenticationUI.currentResourcesProvider()
        let credentialsProvider = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        
        //let operation = buildFakeLoginOperation()
        let operation = buildRealLoginOperation()
        
        var request = Authentication.UIRequest()
        request.tweaks.successAnimationDelay = 650
        //request.options.insert([.allowBiometryFactor])
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

    private func buildFakeLoginOperation() -> AuthenticationUIOperation {
        return OnlineAuthenticationUIOperation(isSerialized: false) { (session, authentication, completionCallback) -> Operation? in
            let task = URLSession.shared.dataTask(with: URL(string: "https://m.google.com")!) { (data, response, error) in
                completionCallback(nil, error != nil ? LimeAuthError(error: error!) : nil)
            }
            task.resume()
            return nil
        }
    }
    
    private func buildRealLoginOperation() -> AuthenticationUIOperation {
        return OnlineAuthenticationUIOperation(isSerialized: true) { (session, authentication, completionCallback) -> Operation? in
            let _ = session.validatePassword(password: authentication.usePassword!){ (error) in
                if let error = error {
                    completionCallback(nil, LimeAuthError(error: error))
                } else {
                    completionCallback(nil, nil)
                }
            }
            return nil
        }
    }
}

extension LimeAuthAuthenticationUI {
    public static func currentResourcesProvider() -> AuthenticationUIProvider {
        return LimeAuthAuthenticationUI.defaultResourcesProvider(theme: .defaultDarkTheme())
    }
}
