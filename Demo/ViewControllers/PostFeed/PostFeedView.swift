//
//  PostFeedView.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import Foundation

@objc protocol PostFeedView {
	func showPosts(posts: [[String: AnyObject]])
	func stopRefreshing()
	func startAnimating()
	func stopAnimating()
	func showRetryAlert()
	func showSettingsAlert()
	func scrollToTop()
	func showLoginPage()
}
