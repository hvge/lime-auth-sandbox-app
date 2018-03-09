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

struct StatusCheckFailureReason {
    let isBlocked: Bool
    let otherError: Error?
    let otherMessage: String?
}

protocol StatusCheckFailureReasonPresenter {
    var statusCheckFailureReason: StatusCheckFailureReason? { get set }
}

class StatusCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateActivationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private weak var updateOperation: Operation?
    
    private func updateActivationStatus() {
        
        if updateOperation != nil {
            // there's already update operation
            return
        }
        
        updateOperation = LimeAuthSession.shared.fetchActivationStatus { (status, _, error) in
            self.updateOperation = nil
            if let status = status {
                let state = status.state
                if state == .active {
                    self.performSegue(withIdentifier: "switchToLogin", sender: nil)
                } else if state == .blocked {
                    let reason = StatusCheckFailureReason(isBlocked: true, otherError: nil, otherMessage: nil)
                    self.performSegue(withIdentifier: "switchToBlocked", sender: reason)
                } else if state == .removed {
                    let alert = UIAlertController(title: "Error", message: "Activation is no longer valid on this device.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action) in
                        LimeAuthSession.shared.removeActivationLocal()
                    })
                    self.present(alert, animated: true, completion: nil)
                } else if state == .otp_Used {
                    self.continueWithBrokenActivation()
                }
            } else {
                let reason = StatusCheckFailureReason(isBlocked: false, otherError: error, otherMessage: error == nil ? "Unknown error" : nil)
                self.performSegue(withIdentifier: "switchToBlocked", sender: reason)
            }
        }
    }
    
    var activationUI: LimeAuthActivationUI?
    
    func continueWithBrokenActivation() {
        let session = LimeAuthSession.shared
        let resourcesProvider = LimeAuthActivationUI.defaultResourcesProvider()
        let credentialsProvider = LimeAuthCredentialsStore(credentials: .defaultCredentials())
        let ui = LimeAuthActivationUI(session: session, uiProvider: resourcesProvider, credentialsProvider: credentialsProvider) { [weak self] (result, finalController) in
            guard let `self` = self else {
                return
            }
            print("Activation result is \(result)")
            finalController?.dismiss(animated: true, completion: nil)
            self.activationUI = nil
        }
        ui.entryScene = .default
        activationUI = ui
        ui.present(to: self)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var failurePresenter = segue.destination as? StatusCheckFailureReasonPresenter, let reason = sender as? StatusCheckFailureReason {
            failurePresenter.statusCheckFailureReason = reason
        }
    }
}
