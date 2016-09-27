//
//  Constants.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
let userDefaults = NSUserDefaults.standardUserDefaults()

struct NotificationKeys {
	static let userLoggedIn = "userLoggedIn"
	static let tokenExpired = "tokenExpired"
	static let uploadFailed = "uploadFailed"
}

struct UserKeys {
	static let userID = "account_id"
	static let userName = "account_username"
	static let token = "token"
}

struct TokenKeys {
	static let accessToken = "access_token"
	static let expiresIn = "expires_in"
	static let tokenDate = "tokenDate"
	static let refreshToken = "refresh_token"
}

struct UserDefaultsKeys {
	static let user = "user"
	static let caching = "caching"
}

struct PostKeys {
	static let title = "title"
	static let imageLink = "link"
	static let description = "description"
	static let width = "width"
	static let height = "height"
}

struct CoreDataKeys {
	static let postEntity = "Post"
	static let postType = "type"
	static let title = "title"
	static let link = "link"
	static let width = "width"
	static let height = "height"
	static let description = "descrip"
}

struct ImageNames {
	static let floatingBtn = "floatingBtn"
	static let gearIcon = "gearIcon"
	static let imgurLogo = "imgurLogo"
	static let revealIcon = "revealIcon"
}

struct ErrorNumbers {
	static let user = 0
	static let connection = -1009
	static let canceled = -999
}