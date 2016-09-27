//
//  Token.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/27/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class Token: AnyObject {
	var accessToken: String
	var expiresIn: Double
	var tokenDate: NSDate
	var refreshToken: String

	init(accessToken: String, expiresIn: Double, tokenDate: NSDate, refreshToken: String) {
		self.accessToken = accessToken
		self.expiresIn = expiresIn
		self.tokenDate = tokenDate
		self.refreshToken = refreshToken
	}

	init?(userDict: [String: AnyObject]) {
		if let accessToken = userDict[TokenKeys.accessToken] as? String,
			expiresIn = Double(userDict[TokenKeys.expiresIn] as! String),
			tokenDate = userDict[TokenKeys.tokenDate] as? NSDate,
			refreshToken = userDict[TokenKeys.refreshToken] as? String {
				self.accessToken = accessToken
				self.expiresIn = expiresIn
				self.tokenDate = tokenDate
				self.refreshToken = refreshToken

		} else {
				return nil
		}
	}

	required convenience init(coder aDecoder: NSCoder) {
		let accessToken = aDecoder.decodeObjectForKey(TokenKeys.accessToken) as? String ?? ""
		let expiresIn = aDecoder.decodeDoubleForKey(TokenKeys.expiresIn)
		let tokenDate = aDecoder.decodeObjectForKey(TokenKeys.tokenDate) as? NSDate ?? NSDate()
		let refreshToken = aDecoder.decodeObjectForKey(TokenKeys.refreshToken) as? String ?? ""

		self.init(accessToken: accessToken,
			expiresIn: expiresIn,
			tokenDate: tokenDate,
			refreshToken: refreshToken)
	}

	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(accessToken, forKey: TokenKeys.accessToken)
		aCoder.encodeObject(tokenDate, forKey: TokenKeys.tokenDate)
		aCoder.encodeDouble(expiresIn, forKey: TokenKeys.expiresIn)
		aCoder.encodeObject(refreshToken, forKey: TokenKeys.refreshToken)
	}
}