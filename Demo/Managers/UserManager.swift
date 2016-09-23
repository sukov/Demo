//
//  UserManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class UserManager {
	static var sharedInstance = UserManager()
	let userDefaults = NSUserDefaults.standardUserDefaults()
	var user: User?

	init() {
		if let decoded = userDefaults.objectForKey(UserDefaultsKeys.user) as? NSData {
			let user = NSKeyedUnarchiver.unarchiveObjectWithData(decoded)
			self.user = user as? User
		}
	}

	func parseToken(url: NSURL) {
		var userDict: [String: String] = [String: String]()
		for param: String in url.absoluteString.componentsSeparatedByString("#")[1].componentsSeparatedByString("&") {
			var item = param.componentsSeparatedByString("=")
			userDict[item[0]] = item[1]
		}

		userDict[UserKeys.tokenDate] = String(NSDate().timeIntervalSince1970)
		user = User(userDict: userDict)
		saveUser()
		NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userLoggedIn, object: nil)
	}

	func isLoggedIn() -> Bool {
		if (user != nil) {
			return true
		} else {
			return false
		}
	}

	func saveUser() {
		if let u = user {
			let encodedData = NSKeyedArchiver.archivedDataWithRootObject(u)
			userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
			userDefaults.synchronize()
		}
	}

	func updateToken(token: String, expiresIn: Double) {
		user?.accessToken = token
		user?.expiresIn = expiresIn
		user?.tokenDate = NSDate()
		saveUser()
	}

	func removeSavedUser() {
		let encodedData = NSKeyedArchiver.archivedDataWithRootObject("nil")
		userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
		userDefaults.synchronize()
	}

}