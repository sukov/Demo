//
//  LocalNotificationsManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/13/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit

class LocalNotificationsManager {

	static var sharedInstance = LocalNotificationsManager()

	init() {
		askForNotificationsPermission()
	}

	private func askForNotificationsPermission() {
		guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
		if settings.types == .None {
			let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
			UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
			return
		}
	}

	func displayFailure() {
		let notification = UILocalNotification()
		notification.fireDate = NSDate()
		notification.alertBody = "Upload failed"
		notification.alertAction = "swipe to retry"
		notification.soundName = UILocalNotificationDefaultSoundName
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

	func displaySuccess() {
		let notification = UILocalNotification()
		notification.fireDate = NSDate()
		notification.category = "success"
		notification.alertBody = "Upload success!"
		notification.alertAction = "swipe to dismiss"
		notification.soundName = UILocalNotificationDefaultSoundName
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
}