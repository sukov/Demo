//
//  UserManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class UserManager {
	static let sharedInstance = UserManager()
	var user: User? {
		didSet {
			saveUser()
		}
	}

	init() {
		if let decoded = userDefaults.objectForKey(UserDefaultsKeys.user) as? NSData {
			if let user = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? User {
				self.user = user
			}
		}
	}

	func isLoggedIn() -> Bool {
		return (UserManager.sharedInstance.user != nil && TokenProvider.sharedInstance.token != nil)
	}

	private func saveUser() {
		if let user = user {
			let encodedData = NSKeyedArchiver.archivedDataWithRootObject(user)
			userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
			userDefaults.synchronize()
		}
	}

	func removeUser() {
		user = nil
		let encodedData = NSKeyedArchiver.archivedDataWithRootObject("nil")
		userDefaults.setObject(encodedData, forKey: UserDefaultsKeys.user)
		userDefaults.synchronize()
	}
}