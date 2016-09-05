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
	var accessToken: String
	var expiresIn: Double
	var tokenDate: NSDate
	var refreshToken: String

	init(userID: Int, userName: String, accessToken: String, expiresIn: Double, tokenDate: NSDate, refreshToken: String) {
		self.userID = userID
		self.userName = userName
		self.accessToken = accessToken
		self.expiresIn = expiresIn
		self.tokenDate = tokenDate
		self.refreshToken = refreshToken
	}

	init(userDict: [String: String]) {
		self.userID = (userDict[UserKeys.userID] != nil) ? Int(userDict[UserKeys.userID]!)! : 0
		self.userName = userDict[UserKeys.userName] ?? ""
		self.accessToken = userDict[UserKeys.accessToken] ?? ""
		self.expiresIn = (userDict[UserKeys.expiresIn] != nil) ? Double(userDict[UserKeys.expiresIn]!)! : 0
		self.tokenDate = NSDate(timeIntervalSince1970: Double(userDict[UserKeys.tokenDate] ?? "") ?? 0)
		self.refreshToken = userDict[UserKeys.refreshToken] ?? ""
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let userID = aDecoder.decodeIntegerForKey(UserKeys.userID)
		let userName = aDecoder.decodeObjectForKey(UserKeys.userName) as? String ?? ""
		let accessToken = aDecoder.decodeObjectForKey(UserKeys.accessToken) as? String ?? ""
		let expiresIn = aDecoder.decodeDoubleForKey(UserKeys.expiresIn)
		let tokenDate = aDecoder.decodeObjectForKey(UserKeys.tokenDate) as? NSDate ?? NSDate()
		let refreshToken = aDecoder.decodeObjectForKey(UserKeys.refreshToken) as? String ?? ""

		self.init(userID: userID,
			userName: userName,
			accessToken: accessToken,
			expiresIn: expiresIn,
			tokenDate: tokenDate,
			refreshToken: refreshToken)
	}

	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeInt(Int32(userID), forKey: UserKeys.userID)
		aCoder.encodeObject(userName, forKey: UserKeys.userName)
		aCoder.encodeObject(accessToken, forKey: UserKeys.accessToken)
		aCoder.encodeInt(Int32(expiresIn), forKey: UserKeys.expiresIn)
		aCoder.encodeObject(refreshToken, forKey: UserKeys.refreshToken)
	}
}