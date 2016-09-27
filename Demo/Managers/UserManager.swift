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
	var user: User? {
		didSet {
			saveUser()
		}
	}

	init() {
		if let decoded = userDefaults.objectForKey(UserDefaultsKeys.user) as? NSData {
			let user = NSKeyedUnarchiver.unarchiveObjectWithData(decoded)
			self.user = user as? User
			TokenProvider.sharedInstance.token = self.user?.token
		}
	}

	func isLoggedIn() -> Bool {
		return UserManager.sharedInstance.user != nil
	}

	private func saveUser() {
		if let user = user {
			let encodedData = NSKeyedArchiver.archivedDataWithRootObject(user)
			userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
			userDefaults.synchronize()
		}
	}

	func removeSavedUser() {
		user = nil
		let encodedData = NSKeyedArchiver.archivedDataWithRootObject("nil")
		userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
		userDefaults.synchronize()
	}
}