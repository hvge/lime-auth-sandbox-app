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

class PendingActivationViewController: UIViewController, TemporaryActivationDataConsumer {

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var activityStep: UILabel!
	@IBOutlet weak var completeActivationButton: UIButton!
	@IBOutlet weak var cancelActivationButton: UIButton!
    
    var timer: Timer?
	
	public var activationData: TemporaryActivationData?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.leftBarButtonItem = nil
		self.completeActivationButton.isHidden = true
		self.cancelActivationButton.isHidden = true
		
		startActivation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activationOperation?.cancel()
    }
	
    private weak var activationOperation: Operation?
	
	private func startActivation() {
		guard let activationData = activationData else {
			D.print("PendingActivationViewController: ActivationData is not set.")
			return
		}
        
        activityStep.text = "Creating activation"
        
		activationOperation = LimeAuthSession.shared.createActivation(name: UIDevice.current.name, activationCode: activationData.activationCode) { (result, error) in
            if let result = result, let activationData = self.activationData {
                self.completeActivation(activationResult: result, activationData: activationData)
            } else {
                self.fail(with: error)
            }
		}
	}
    
    private func completeActivation(activationResult: PA2ActivationResult, activationData: TemporaryActivationData) {
		//
        let authentication = PowerAuthAuthentication()
        authentication.usePossession = true
        authentication.usePassword = activationData.password
        authentication.useBiometry = activationData.allowBiometry
		//
        let _ = LimeAuthSession.shared.commitActivation(authentication: authentication) { (error) in
            if let error = error {
                self.fail(with: error)
            } else {
				self.cancelActivationButton.isHidden = false
                self.activityStep.text = "Please commit activation!\n\nFingerprint: \(activationResult.activationFingerprint)"
				self.waitForCommit()
            }
        }
    }
    
    private func fail(with error: Error?) {
        let message = error?.localizedDescription ?? "Unknown error"
        let fullMessage = "Activation did fail.\n\nError: \(message)"
        self.activityStep.text = fullMessage
        
        let alert = UIAlertController(title: "Error", message: fullMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action)->Void in
            LimeAuthSession.shared.removeActivationLocal()
            self.activationData?.onFailure?()
        })
        self.present(alert, animated: true, completion: nil)
    }
	
    private func waitForCommit(status: PA2ActivationStatus? = nil) {
        
        var waitForAWhile = true
        if let status = status {
            if status.state == .active {
                self.activityStep.text = "Now you can start using the application."
                self.activityIndicator.isHidden = true
                self.cancelActivationButton.isHidden = true
                self.completeActivationButton.isHidden = false
                return
            } else if status.state == .removed {
                self.activationData?.onFailure?()
                return
            } else if status.state == .blocked {
                self.activityStep.text = "Activation is blocked."
            }
        } else {
            waitForAWhile = false
        }
        
        if waitForAWhile {
            self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (timer) in
                self?.waitForCommit()
            }
            return
        }
        
		self.activationOperation = LimeAuthSession.shared.fetchActivationStatus { (status, _, error) in
            self.waitForCommit(status: status)
		}
	}

	@IBAction func cancelActivation(_ sender: Any) {
		LimeAuthSession.shared.removeActivationLocal()
		self.activationData?.onFailure?()
	}
	@IBAction func successAction(_ sender: Any) {
		self.activationData?.onSuccess?()
	}
}
