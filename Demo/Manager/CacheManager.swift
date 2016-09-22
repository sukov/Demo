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
	private var isCachingOn: Bool

	init() {
		cache = NSCache()
		isCachingOn = true
	}

	func cachePosts(posts: [[String: AnyObject]], type: PostsType) {
		if var cachedPosts = cache.objectForKey(type.rawValue) as? [[String: AnyObject]] {
			cachedPosts.appendContentsOf(posts)
			cache.setObject(cachedPosts, forKey: type.rawValue)
		} else {
			cache.setObject(posts, forKey: type.rawValue)
		}

		CoreDataManager.sharedInstance.savePosts(posts, type: type)
	}

	func clearCachedPosts(type: PostsType) {
		cache.removeObjectForKey(type.rawValue)
		CoreDataManager.sharedInstance.removePosts(type)
	}

	func getCachedPosts(type: PostsType) -> [[String: AnyObject]]? {
		if (!isCachingOn) {
			return nil
		} else if let posts = cache.objectForKey(type.rawValue) as? [[String: AnyObject]] {
			return posts
		} else {
			return loadDiscCache(type)
		}
	}

	func loadDiscCache(type: PostsType) -> [[String: AnyObject]]? {
		if let savedCache = CoreDataManager.sharedInstance.getPosts(type) {
			cache.setObject(savedCache, forKey: type.rawValue)
			return savedCache
		}
		return nil
	}

	func setCachingON() {
		isCachingOn = true
	}

	func setCachingOFF() {
		isCachingOn = false
	}
}