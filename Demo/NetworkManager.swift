//
//  NetworkManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkManager {
	let clientID = "3c2821bc2936232"
	let clientSecret = "65c4223ede9163278443b6255eeb7f3959d52b20"

	static var sharedInstance = NetworkManager()

	func requestToken() {
		if let authURL = NSURL(string: "https://api.imgur.com/oauth2/authorize?client_id=3c2821bc2936232&response_type=token&state=APPLICATION_STATE") {
			UIApplication.sharedApplication().openURL(authURL)
		}
	}

	func refreshToken() {
		let URL = "https://api.imgur.com/oauth2/token?grant_type=refresh_token&client_id=3c2821bc2936232&client_secret=65c4223ede9163278443b6255eeb7f3959d52b20&refresh_token=373b97e505b3df6c17cef5abd1c961de690310de"
		Alamofire.request(.POST, URL)
			.validate()
			.responseJSON { response in
				do {
					print(response.result.error)
				}
		}
	}

	func getHotImages(token: String, pageNumber: Int, complete: (images: [[String: AnyObject]]?, error: NSError?) -> Void) {
		let headers = ["Authorization": "Bearer \(token)"]
		Alamofire.request(.GET, "https://api.imgur.com/3/gallery/hot/viral/\(pageNumber)", parameters: ["": ""], encoding: ParameterEncoding.URL, headers: headers)
			.validate()
			.responseJSON { response in
				var images: [[String: AnyObject]]
				if (response.result.isSuccess) {
					do { let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
						if let imagesFromJson = json["data"] as? [[String: AnyObject]] {
							images = imagesFromJson
							var i1: Int = 0
							for i in 0..<images.count {
								if (images[i - i1]["is_album"] as? Int == 1) {
									images.removeAtIndex(i - i1)
									i1 = i1 + 1
								}
							}
							complete(images: images, error: nil)

						}
					} catch {
						complete(images: nil, error: response.result.error)
					}
				} else {
					complete(images: nil, error: response.result.error)
				}
		}
	}

	func getPopularImages(token: String, pageNumber: Int, complete: (images: [[String: AnyObject]]?, error: NSError?) -> Void) {
		let headers = ["Authorization": "Bearer \(token)"]
		Alamofire.request(.GET, "https://api.imgur.com/3/gallery/top/viral/\(pageNumber)", parameters: ["": ""], encoding: ParameterEncoding.URL, headers: headers)
			.validate()
			.responseJSON { response in
				var images: [[String: AnyObject]]
				if (response.result.isSuccess) {
					do { let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
						if let imagesFromJson = json["data"] as? [[String: AnyObject]] {
							images = imagesFromJson
							var i1: Int = 0
							for i in 0..<images.count {
								if (images[i - i1]["is_album"] as? Int == 1) {
									images.removeAtIndex(i - i1)
									i1 = i1 + 1
								}
							}
							complete(images: images, error: nil)

						}
					} catch {
						complete(images: nil, error: response.result.error)
					}
				} else {
					complete(images: nil, error: response.result.error)
				}
		}
	}

	func getUserImages(userName: String, token: String, pageNumber: Int, complete: (images: [[String: AnyObject]]?, error: NSError?) -> Void) {
		let headers = ["Authorization": "Bearer \(token)"]
		Alamofire.request(.GET, "https://api.imgur.com/3/account/\(userName)/images", parameters: ["": ""], encoding: ParameterEncoding.URL, headers: headers)
			.validate()
			.responseJSON { response in
				var images: [[String: AnyObject]]
				if (response.result.isSuccess) {
					do { let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
						if let imagesFromJson = json["data"] as? [[String: AnyObject]] {
							images = imagesFromJson
							var i1: Int = 0
							for i in 0..<images.count {
								if (images[i - i1]["is_album"] as? Int == 1) {
									images.removeAtIndex(i - i1)
									i1 = i1 + 1
								}
							}
							complete(images: images, error: nil)

						}
					} catch {
						complete(images: nil, error: response.result.error)
					}
				} else {
					complete(images: nil, error: response.result.error)
				}
		}
	}
}