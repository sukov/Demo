//
//  CoreDataManager.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/19/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
	static var sharedInstance = CoreDataManager()
	let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

	func savePostsByType(postsData: [[String: AnyObject]], type: PostsType) {
		let postEntity = NSEntityDescription.entityForName(CoreDataKeys.postEntity, inManagedObjectContext: managedContext)

		for postData in postsData {
			let newPost = NSManagedObject(entity: postEntity!, insertIntoManagedObjectContext: managedContext)
			newPost.setValue(postData[PostKeys.title] as? String ?? "", forKey: CoreDataKeys.title)
			newPost.setValue(postData[PostKeys.imageLink] as? String ?? "", forKey: CoreDataKeys.link)
			newPost.setValue(postData[PostKeys.description] as? String ?? "", forKey: CoreDataKeys.description)
			newPost.setValue(postData[PostKeys.width] as? Float ?? 250, forKey: CoreDataKeys.width)
			newPost.setValue(postData[PostKeys.height] as? Float ?? 350, forKey: CoreDataKeys.height)
			newPost.setValue(type.rawValue, forKey: CoreDataKeys.postType)
		}
		do {
			try managedContext.save()
		} catch { }
	}

	func removePostsByType(type: PostsType) {
		let fetchRequest = NSFetchRequest(entityName: CoreDataKeys.postEntity)
		fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
		let coord = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

		do {
			try coord.executeRequest(deleteRequest, withContext: self.managedContext)
		} catch let error as NSError {
			debugPrint(error)
		}
	}

	func removeAllPosts() {
		let fetchRequest = NSFetchRequest(entityName: CoreDataKeys.postEntity)
		let coord = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

		do {
			try coord.executeRequest(deleteRequest, withContext: self.managedContext)
		} catch let error as NSError {
			debugPrint(error)
		}
	}

	func getPostsByType(type: PostsType) -> [[String: AnyObject]]? {
		if let postsManagedObjects = getPostsManagedObjects(type) {
			var posts = [[String: AnyObject]]()
			for postManagedObject in postsManagedObjects {
				var post = [String: AnyObject]()
				post[PostKeys.title] = postManagedObject.valueForKey(CoreDataKeys.title) as? String ?? ""
				post[PostKeys.imageLink] = postManagedObject.valueForKey(CoreDataKeys.link) as? String ?? ""
				post[PostKeys.description] = postManagedObject.valueForKey(CoreDataKeys.description) as? String ?? ""
				post[PostKeys.width] = postManagedObject.valueForKey(CoreDataKeys.width) as? Float ?? 250
				post[PostKeys.height] = postManagedObject.valueForKey(CoreDataKeys.height) as? Float ?? 350
				posts.append(post)
			}
			return posts
		} else { return nil }
	}

	private func getPostsManagedObjects(type: PostsType) -> [NSManagedObject]? {
		let fetchRequest = NSFetchRequest(entityName: CoreDataKeys.postEntity)
		fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)

		var posts: [NSManagedObject]?

		do {
			let results =
				try managedContext.executeFetchRequest(fetchRequest)
			posts = results as? [NSManagedObject]
		} catch {
			let postsByTypeEntity = NSEntityDescription.entityForName(CoreDataKeys.postEntity, inManagedObjectContext: managedContext)
			let newType = NSManagedObject(entity: postsByTypeEntity!, insertIntoManagedObjectContext: managedContext)
			newType.setValue(type.rawValue, forKey: CoreDataKeys.postType)
			do {
				try managedContext.save()
			} catch { }

			return nil
		}
		return posts
	}
}