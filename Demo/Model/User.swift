//
//  User.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
	var userID: Int
	var userName: String
	var token: Token?

	init(userID: Int, userName: String, token: Token?) {
		self.userID = userID
		self.userName = userName
		self.token = token
	}

	init?(userDict: [String: AnyObject]) {
		self.userID = (userDict[UserKeys.userID] != nil) ? Int(userDict[UserKeys.userID]! as? String ?? "")! : 0
		self.userName = (userDict[UserKeys.userName] as? String) ?? ""
		if let token = Token(userDict: userDict) {
			self.token = token
		} else {
			return nil
		}
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let userID = aDecoder.decodeIntegerForKey(UserKeys.userID)
		let userName = aDecoder.decodeObjectForKey(UserKeys.userName) as? String ?? ""
		let token = Token(coder: aDecoder)

		self.init(userID: userID, userName: userName, token: token)
	}

	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeInt(Int32(userID), forKey: UserKeys.userID)
		aCoder.encodeObject(userName, forKey: UserKeys.userName)
		token?.encodeWithCoder(aCoder)
	}
}