//
//  TokenProvider.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/14/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit

class TokenProvider {
	private let clientID = "3c2821bc2936232"
	private let clientSecret = "65c4223ede9163278443b6255eeb7f3959d52b20"
	var token: Token?

	static var sharedInstance = TokenProvider()

	func parseToken(url: NSURL) {
		var userDict: [String: AnyObject] = [:]
		for param: String in url.absoluteString.componentsSeparatedByString("#")[1].componentsSeparatedByString("&") {
			var item = param.componentsSeparatedByString("=")
			userDict[item[0]] = item[1]
		}
		userDict[TokenKeys.tokenDate] = NSDate()

		if let token = Token(userDict: userDict) { // if not nil = token is valid
			self.token = token
			UserManager.sharedInstance.user = User(userDict: userDict)
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userLoggedIn, object: nil)
		}
	}

	func updateToken(token: String, expiresIn: Double) {
		self.token?.accessToken = token
		self.token?.expiresIn = expiresIn
		self.token?.tokenDate = NSDate()
		if let token = self.token {
			UserManager.sharedInstance.user?.token = token
		}
	}

	func requestToken() {
		if let authURL = NSURL(string: "https://api.imgur.com/oauth2/authorize?client_id=3c2821bc2936232&response_type=token&state=APPLICATION_STATE") {
			UIApplication.sharedApplication().openURL(authURL)
		}
	}

	func refreshToken() {
		guard token != nil else {
			return
		}

		let params = ["refresh_token": token!.refreshToken, "client_id": clientID, "client_secret": clientSecret, "grant_type": "refresh_token"]

		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			Group.sharedInstance.enter(.RefreshToken)

			let requestURL = NSURL(string: "https://api.imgur.com/oauth2/token")!
			let request = NSMutableURLRequest(URL: requestURL)
			request.HTTPMethod = "POST"
			do {
				let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
				request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
				request.HTTPBody = jsonData
			} catch { }

			let session = NSURLSession.sharedSession()
			let task = session.dataTaskWithRequest(request) { (data, response, error) in
				if (error == nil) {
					do {
						if let _data = data {
							let json = try NSJSONSerialization.JSONObjectWithData(_data, options: .AllowFragments)
							if let newToken = json as? [String: AnyObject] {
								if (newToken["success"] as? Int != 0) {
									self.updateToken(
										newToken[TokenKeys.accessToken] as! String,
										expiresIn: newToken[TokenKeys.expiresIn] as! Double)
								}
							}
						}

					} catch { }
				}
				Group.sharedInstance.leave(.RefreshToken)
			}
			task.resume()
		}
	}

	func isTokenExpired() -> Bool {
		if let token = token {
			if (NSDate().timeIntervalSinceDate(token.tokenDate) > (token.expiresIn - 2)) {
				return true
			}
		}
		return false
	}

	func removeToken() {
		token = nil
	}
}