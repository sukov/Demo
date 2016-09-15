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

	static var sharedInstance = TokenProvider()

	func requestToken() {
		if let authURL = NSURL(string: "https://api.imgur.com/oauth2/authorize?client_id=3c2821bc2936232&response_type=token&state=APPLICATION_STATE") {
			UIApplication.sharedApplication().openURL(authURL)
		}
	}

	func refreshToken() {
		let params = ["refresh_token": UserManager.sharedInstance.user!.refreshToken, "client_id": clientID, "client_secret": clientSecret, "grant_type": "refresh_token"]

		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			Group.sharedInstance.enter(.RefreshToken)
			print("refreshTokenENTER")

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
						let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
						if let newToken = json as? [String: AnyObject] {
							if (newToken["success"] as? Int != 0) {
								print(newToken)
								UserManager.sharedInstance.updateToken(
									newToken[UserKeys.accessToken] as! String,
									expiresIn: newToken[UserKeys.expiresIn] as! Double)
							}
						}

					} catch { }
				}
				print("refreshTokenLEAVE")
				Group.sharedInstance.leave(.RefreshToken)
			}
			task.resume()
		}

	}

	func isTokenExpired() -> Bool {
		if let u = UserManager.sharedInstance.user {
			if (NSDate().timeIntervalSinceDate(u.tokenDate) > (u.expiresIn - 2)) {
				return true
			}
		}
		return false
	}

}