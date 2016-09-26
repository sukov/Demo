//
//  AlertFactory.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/23/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class AlertFactory {
	static var retryActionClosure: Optional < () -> Void >
	static var settingsActionClosure: Optional < () -> Void >

	static func retryUpload() -> UIAlertController {
		let alert = UIAlertController(title: "Upload failed", message: "Error image not uploaded. Would you like to retry?", preferredStyle: UIAlertControllerStyle.Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		let retryAction = UIAlertAction(title: "Retry", style: .Default) { (alert) in
			retryActionClosure?()
		}
		alert.addAction(defaultAction)
		alert.addAction(retryAction)

		return alert
	}

	static func settings() -> UIAlertController {
		let alert = UIAlertController(title: "No internet connection present", message: "Open settings?", preferredStyle: UIAlertControllerStyle.Alert)
		let defaultAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
		let openCellularAction = UIAlertAction(title: "Settings", style: .Default) { (alert) in
			settingsActionClosure?()
			UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=ROOT")!) // prefs:root=General&path=Music
		}
		alert.addAction(defaultAction)
		alert.addAction(openCellularAction)

		return alert
	}
}