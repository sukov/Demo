//
//  CoreDataManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/19/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class CoreDataManager {
	static var sharedInstance = CoreDataManager()
	let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

	func savePost(postData: [String: String]) {
		// TO-DO
	}

	func getPosts(type: PostsType) -> [String: AnyObject] {
		// TO-DO
		return [:]
	}
}