//
//  CacheManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/19/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class CacheManager {
	static var sharedInstance = CacheManager()
	private let cache: NSCache

	init() {
		cache = NSCache()
	}

	func cachePosts(posts: [String: AnyObject], type: PostsType) {
		cache.setObject(posts, forKey: type.rawValue)
	}

	func getCachedPosts(type: PostsType) -> [String: AnyObject]? {
		return cache.objectForKey(type.rawValue) as? [String: AnyObject]
	}
}