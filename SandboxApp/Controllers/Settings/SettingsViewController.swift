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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var biometryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBiometryButton()
    }
    
    @IBAction func changePinAction(_ sender: Any) {
        let session = LimeAuthSession.shared
        let uiProvider = LimeAuthAuthenticationUI.defaultResourcesProvider()
        let credentials = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        let ui = LimeAuthAuthenticationUI.uiForChangePassword(session: session, uiProvider: uiProvider, credentialsProvider: credentials) { (result, finalController) in
            self.authUI = nil
            finalController?.dismiss(animated: true, completion: nil)
        }
        authUI = ui
        ui.present(to: self)
    }
    
    
    @IBAction func removeActivation(_ sender: Any) {
        let session = LimeAuthSession.shared
        let uiProvider = LimeAuthAuthenticationUI.defaultResourcesProvider()
        let credentials = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        let ui = LimeAuthAuthenticationUI.uiForRemoveActivation(session: session, uiProvider: uiProvider, credentialsProvider: credentials) { (result, finalController) in
            self.authUI = nil
            finalController?.dismiss(animated: true, completion: nil)
        }
        authUI = ui
        ui.present(to: self)
    }
    
    @IBAction func changeBiometryAction(_ sender: Any) {
        if LimeAuthSession.shared.hasBiometryFactor {
            removeBiometry()
        } else {
            addBiometry()
        }
    }
    
    
    func updateBiometryButton() {
        // This example shows how to simply determine biometry support.
        //   "deviceCheck" - tests whether device actually supports biometry right now
        let deviceCheck = LimeAuthSession.canUseBiometricAuthentication
        //   "configCheck" - tests whether also it's enabled in credentials config.
        //                   this is useful when you're working on reusable app skeleton and
        //                   you're expecting that some derived apps simply won't use biometry at all.
        let credentialsProvider = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        let configCheck = credentialsProvider.credentials.biometry.isSupportedOnDevice
        // Of course, nNormally only one test is required :)
        if deviceCheck && configCheck {
            if LimeAuthSession.shared.hasBiometryFactor {
                biometryButton.setTitle("Remove biometry", for: .normal)
            } else {
                biometryButton.setTitle("Add biometry", for: .normal)
            }
            biometryButton.isHidden = false
        } else {
            biometryButton.isHidden = true
        }
    }
    
    
    func removeBiometry() {
        _ = LimeAuthSession.shared.removeBiometryFactor { (removed) in
            self.updateBiometryButton()
        }
    }
    
    var authUI: LimeAuthAuthenticationUI?
    
    func addBiometry() {
        let session = LimeAuthSession.shared
        let uiProvider = LimeAuthAuthenticationUI.defaultResourcesProvider()
        let credentials = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        let ui = LimeAuthAuthenticationUI.uiForEnableBiometry(session: session, uiProvider: uiProvider, credentialsProvider: credentials) { (result, finalController) in
            self.authUI = nil
            self.updateBiometryButton()
            finalController?.dismiss(animated: true, completion: nil)
        }
        authUI = ui
        ui.present(to: self)
    }
}
