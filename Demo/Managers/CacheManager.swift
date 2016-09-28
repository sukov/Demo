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
		isCachingOn = userDefaults.boolForKey(UserDefaultsKeys.caching)
	}

	func cachePosts(posts: [[String: AnyObject]], type: PostsType) {
		if var cachedPosts = cache.objectForKey(type.rawValue) as? [[String: AnyObject]] {
			cachedPosts.appendContentsOf(posts)
			cache.setObject(cachedPosts, forKey: type.rawValue)
		} else {
			cache.setObject(posts, forKey: type.rawValue)
		}
	}

	func clearCachedPosts(type: PostsType) {
		cache.removeObjectForKey(type.rawValue)
	}

	func clearAllCache() {
		cache.removeAllObjects()
	}

	func getCachedPosts(type: PostsType) -> [[String: AnyObject]]? {
		if (!isCachingOn) {
			return nil
		} else if let posts = cache.objectForKey(type.rawValue) as? [[String: AnyObject]] {
			return posts
		} else {
			return nil
		}
	}

	func setCacheForType(posts: [[String: AnyObject]], type: PostsType) {
		cache.setObject(posts, forKey: type.rawValue)
	}

	func setCachingON() {
		isCachingOn = true
		userDefaults.setBool(true, forKey: UserDefaultsKeys.caching)
	}

	func setCachingOFF() {
		isCachingOn = false
		userDefaults.setBool(false, forKey: UserDefaultsKeys.caching)
	}

	func isCachingON() -> Bool {
		return isCachingOn
	}
}