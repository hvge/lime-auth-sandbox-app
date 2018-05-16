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

class StartActivationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var activationUI: LimeAuthActivationUI?
    
    @IBAction func startActivationAction(_ sender: Any) {
        let session = LimeAuthSession.shared
        
        let resourcesProvider = LimeAuthActivationUI.defaultResourcesProvider(activationTheme: .defaultDarkTheme(), authenticationTheme: .defaultDarkTheme())
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
