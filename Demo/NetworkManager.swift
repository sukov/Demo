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
	private var request: Alamofire.Request?
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

	func getPosts(postsType: PostsType, pageNumber: Int, complete: (images: [[String: AnyObject]]?, error: NSError?) -> Void) {
		guard UserManager.sharedInstance.user != nil else {
			complete(images: nil, error: nil)
			return
		}

		activityIndicatorON()
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {

			self.lock.lock()
			if (TokenProvider.sharedInstance.isTokenExpired()) {
				TokenProvider.sharedInstance.refreshToken()
			}

			Group.sharedInstance.waitForGroupToFinnish(.RefreshToken)
			self.lock.unlock()

			var url: String
			switch postsType {
			case .Hot: url = "https://api.imgur.com/3/gallery/hot/viral/\(pageNumber)"
			case .Popular: url = "https://api.imgur.com/3/gallery/top/viral/\(pageNumber)"
			case .User: url = "https://api.imgur.com/3/account/\(UserManager.sharedInstance.user!.userName)/images/\(pageNumber)"
			}

			let headers = ["Authorization": "Bearer \(UserManager.sharedInstance.user!.accessToken)"]

			Alamofire.request(.GET, url, parameters: ["": ""], encoding: ParameterEncoding.URL, headers: headers)
				.validate()
				.responseJSON { [weak self] response in
					var images: [[String: AnyObject]]
					if (response.result.isSuccess) {
						do {
							if let data = response.data {
								let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
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
							}
						} catch {
							complete(images: nil, error: response.result.error)
						}
					} else {
						complete(images: nil, error: response.result.error)
					}
					self?.activityIndicatorOFF()

			}
		}
	}

	func uploadImage(image: UIImage, title: String, description: String, complete: (success: Bool) -> Void) {

		activityIndicatorON()
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {

			self.lock.lock()
			if (TokenProvider.sharedInstance.isTokenExpired()) {
				TokenProvider.sharedInstance.refreshToken()
			}

			Group.sharedInstance.waitForGroupToFinnish(.RefreshToken)
			self.lock.unlock()

			let token = UserManager.sharedInstance.user!.accessToken

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
					self?.request = upload.responseData { (response: Response<NSData, NSError>) -> Void in
						switch response.result {
						case .Success:
							complete(success: true)
						case .Failure(_):
							NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.uploadFailed, object: nil)
							complete(success: false)
						}
					}
				case .Failure(_):
					complete(success: false)
				}
				self?.activityIndicatorOFF()
				}

			)
		}
	}

	func cancelAllRequests() {
		Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
	}

	func cancelLastUpload() {
		request?.cancel()
	}

	func retryLastUpload(complete: (success: Bool) -> Void) {
		if let _lastUpload = lastUpload {
			uploadImage(_lastUpload.image, title: _lastUpload.title, description: _lastUpload.description, complete: { (success) in
				complete(success: success)
			})
		}
	}

}