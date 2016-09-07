//
//  PostFeedView.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import Foundation

@objc protocol PostFeedView {
	func showPictures(images: [[String: AnyObject]])
	func stopRefreshing()
	func startAnimating()
	func stopAnimating()
}
