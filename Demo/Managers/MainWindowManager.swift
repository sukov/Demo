//
//  MainWindowManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/28/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class MainWindowManager {
	static let sharedInstance = MainWindowManager()

	@objc func changeWindow() {
		if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
			app.window?.rootViewController = MainAssembly.sharedInstance.getRootController()
		}
	}
}
