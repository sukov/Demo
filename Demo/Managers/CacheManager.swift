//
//  CacheManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/19/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class CacheManager {
	static let sharedInstance = CacheManager()
	private let cache: NSCache
	var isCachingOn: Bool {
		willSet(newValue) {
			userDefaults.setBool(newValue, forKey: UserDefaultsKeys.caching)
		}
	}

	init() {
		cache = NSCache()
		isCachingOn = userDefaults.boolForKey(UserDefaultsKeys.caching)
	}

	func updateCacheForType(posts: [[String: AnyObject]], type: PostsType) {
		if var cachedPosts = cache.objectForKey(type.rawValue) as? [[String: AnyObject]] {
			cachedPosts.appendContentsOf(posts)
			cache.setObject(cachedPosts, forKey: type.rawValue)
		} else {
			cache.setObject(posts, forKey: type.rawValue)
		}
	}

	func clearPostsByType(type: PostsType) {
		cache.removeObjectForKey(type.rawValue)
	}

	func clearAllCache() {
		cache.removeAllObjects()
	}

	func getCachedPostsByType(type: PostsType) -> [[String: AnyObject]]? {
		return isCachingOn ? (cache.objectForKey(type.rawValue) as? [[String: AnyObject]]) : nil
	}

}