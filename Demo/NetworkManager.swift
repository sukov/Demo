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
	private var lastUpload: (image: UIImage, title: String, description: String)?
	private let requestGroup = dispatch_group_create();
	private let refreshTokenGroup = dispatch_group_create();
	private var allowRefreshToken: Bool = true
	private var lock = NSLock()

	static var sharedInstance = NetworkManager()

	func activityIndicatorON() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
	}

	func activityIndicatorOFF() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
	}

	func getPosts(postsType: PostsType, pageNumber: Int, complete: (posts: [[String: AnyObject]]?, error: NSError?) -> Void) {
		guard TokenProvider.sharedInstance.token != nil && UserManager.sharedInstance.user != nil else {
			complete(posts: nil, error: nil)
			return
		}

		activityIndicatorON()
		checkForTokenExpiry()

		var url: String
		switch postsType {
		case .Hot: url = "https://api.imgur.com/3/gallery/hot/viral/\(pageNumber)"
		case .Popular: url = "https://api.imgur.com/3/gallery/top/viral/\(pageNumber)"
		case .User: url = "https://api.imgur.com/3/account/\(UserManager.sharedInstance.user!.userName)/images/\(pageNumber)"
		}

		let headers = ["Authorization": "Bearer \(TokenProvider.sharedInstance.token!.accessToken)"]

		Alamofire.request(.GET, url, parameters: ["": ""], encoding: ParameterEncoding.URL, headers: headers)
			.validate()
			.responseJSON { [weak self] response in
				var posts: [[String: AnyObject]]
				if (response.result.isSuccess) {
					do {
						if let data = response.data {
							let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
							if let postsFromJson = json["data"] as? [[String: AnyObject]] {
								posts = postsFromJson
								var removedItems: Int = 0
								for i in 0..<posts.count {
									if (posts[i - removedItems]["is_album"] as? Int == 1) {
										posts.removeAtIndex(i - removedItems)
										removedItems = removedItems + 1
									}
								}
								complete(posts: posts, error: nil)
							}
						}
					} catch {
						complete(posts: nil, error: response.result.error)
					}
				} else {
					complete(posts: nil, error: response.result.error)
				}
				self?.activityIndicatorOFF()
		}

	}

	func uploadImage(image: UIImage, title: String, description: String, complete: (error: Int?) -> Void) {
		guard TokenProvider.sharedInstance.token != nil else {
			complete(error: ErrorNumbers.user)
			return
		}

		activityIndicatorON()
		checkForTokenExpiry()

		let token = TokenProvider.sharedInstance.token!.accessToken

		self.lastUpload = (image: image, title: title, description: description)
		let headers = ["Authorization": "Bearer \(token)"]
		let parameters = ["title": title, "description": description]

		Alamofire.upload(.POST, "https://api.imgur.com/3/upload", headers: headers, multipartFormData: {
			multipartFormData in

			multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(image)!, name: "image")

			for (key, value) in parameters {
				multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
			}

			}, encodingCompletion: { [weak self]
			encodingResult in

			switch encodingResult {
			case .Success(let upload, _, _):
//				upload.progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
//					print(totalBytesRead)
//				})
				upload.responseData { (response: Response<NSData, NSError>) -> Void in
					switch response.result {
					case .Success:
						complete(error: nil)
					case .Failure(_):
						NSNotificationCenter.defaultCenter().postNotificationName(
							NotificationKeys.uploadFailed,
							object: nil,
							userInfo: ["error": response.result.error?.code ?? (-1)])
						complete(error: response.result.error?.code)
					}
				}
			case .Failure(_):
				complete(error: nil)
			}
			self?.activityIndicatorOFF()
			}
		)

	}

	func cancelAllRequests() {
		Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) in
			tasks.forEach { $0.cancel() }
		}
	}

	func retryLastUpload(complete: (error: Int?) -> Void) {
		if let _lastUpload = lastUpload {
			uploadImage(_lastUpload.image, title: _lastUpload.title, description: _lastUpload.description, complete: { (success) in
				complete(error: success)
			})
		}
	}

	private func checkForTokenExpiry() {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			self.lock.lock()

			if (TokenProvider.sharedInstance.isTokenExpired()) {
				TokenProvider.sharedInstance.refreshToken()
			}

			Group.sharedInstance.waitForGroupToFinnish(.RefreshToken)
			self.lock.unlock()
		}
	}
}