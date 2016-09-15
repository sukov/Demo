//
//  Constants.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

struct NotificationKeys {
	static let userLoggedIn = "userLoggedIn"
	static let tokenExpired = "tokenExpired"
	static let uploadFailed = "uploadFailed"
}

struct UserKeys {
	static var userID = "account_id"
	static var userName = "account_username"
	static var accessToken = "access_token"
	static var expiresIn = "expires_in"
	static var tokenDate = "tokenDate"
	static var refreshToken = "refresh_token"
}

struct UserDefaultsKeys {
	static var user = "user"
}