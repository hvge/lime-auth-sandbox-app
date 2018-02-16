//
//  AppDelegate.swift
//  SandboxApp
//
//  Created by Juraj Durech on 16/02/2018.
//  Copyright © 2018 Lime - HighTech Solutions. All rights reserved.
//

import UIKit
import LimeCore
import LimeAuth
import PowerAuth2

typealias D = LimeDebug


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Setup shared configurations
		configureLibraries()
		
		// First access to shared configurations
		let hasActivation = LimeAuthSession.shared.hasValidActivation
		if hasActivation {
			D.print("AppStart: You have a valid activation")
		} else {
			D.print("AppStart: There's no valid activation")
		}
		
		let debugBuild = PA2System.isInDebug()
		if debugBuild {
			D.print("AppStart: PowerAuth library is compiled as DEBUG build.")
			#if !DEBUG
				fatalError("AppStart: You should not mix debug library and release application!")
			#endif
		}
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


	func configureLibraries() {
		LimeConfig.registerConfigDomains = { (config) in
			guard let authSession = config.registerAuthSession,
				let localization = config.registerLocalization else {
					fatalError("Cannot access shared configurations.")
				}
			
			// loclizations
			localization.defaultLanguage = "en"
			
			// auth session
			let powerAuth = authSession.powerAuth
			powerAuth.appKey = "QdGi0mefDLSauL2tiQwSOw=="
			powerAuth.appSecret = "Ec1RlAr6B3Il6wEg9OQLXA=="
			powerAuth.masterServerPublicKey = "BGyETh1n9W20nHaxj9n2Fm72N/0/i7gKcBSyL4nCqLAqsD/tkrzPA3dibvmYXGL2NPTusUhFISu2a03PtLijtFs="
			powerAuth.baseEndpointUrl = "http://localhost:8080/powerauth-webflow"
			powerAuth.instanceId = "SharedSession"
		}
	}
	
}

