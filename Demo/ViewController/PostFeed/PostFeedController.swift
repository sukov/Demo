//
//  PostFeedController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import UIKit
import Foundation
import SVPullToRefresh

class PostFeedController: UIViewController {
	private var presenter: PostFeedPresenter
	private var collectionView: UICollectionView!
	private var floatingButton: UIButton!
	private var images: [[String: AnyObject]]?

	init(presenter: PostFeedPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		removeObservers()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavigationBar()
		setupConstraints()
		setDelegates()
		addObservers()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	func setupNavigationBar() {
		let revealBtn = UIButton()
		revealBtn.setImage(UIImage(named: "revealIcon"), forState: .Normal)
		revealBtn.frame = CGRectMake(0, 0, 30, 30)
		let revealBarButton = UIBarButtonItem()
		revealBarButton.customView = revealBtn
		navigationItem.leftBarButtonItem = revealBarButton
		let revealController = revealViewController()
		revealBtn.addTarget(revealController, action: #selector(revealController.revealToggle(_:)), forControlEvents: .TouchUpInside)
	}

	func setupViews() {
		view.backgroundColor = UIColor.whiteColor()
		floatingButton = UIButton()
		collectionView = UICollectionView(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
		floatingButton.setImage(UIImage(named: "floatingBtn"), forState: UIControlState.Normal)
		floatingButton.addTarget(self, action: #selector(floatingButtonTapped), forControlEvents: .TouchUpInside)
		collectionView.registerClass(PostFeedCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.addPullToRefreshWithActionHandler { [weak self] in
			self?.presenter.refreshData()
		}

		collectionView.addInfiniteScrollingWithActionHandler { [weak self] in
			self?.presenter.loadNew()
		}
		collectionView.triggerPullToRefresh()
		collectionView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White

		view.addSubview(collectionView)
		view.addSubview(floatingButton)
	}

	func setupConstraints() {
		collectionView.snp_makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			make.top.equalTo(self.view).offset(65)
			make.bottom.equalTo(self.view)
		}

		floatingButton.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom).offset(-15)
			make.right.equalTo(self.view.snp_right).offset(-15)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}

	}

	func setDelegates() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(returnedFromBackground), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
	}

	func removeObservers() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	func returnedFromBackground() {
		presenter.refreshData()
	}

	func floatingButtonTapped() {
		navigationController?.pushViewController(MainAssembly.sharedInstance.getCreatePostController(), animated: true)
	}
}

extension PostFeedController: PostFeedView {
	func showPictures(images: [[String: AnyObject]]) {
		self.images = images
		collectionView.reloadData()
	}

	func stopRefreshing() {
		collectionView.pullToRefreshView.stopAnimating()
	}

	func startAnimating() {
		collectionView.infiniteScrollingView.startAnimating()
	}

	func stopAnimating() {
		collectionView.infiniteScrollingView.stopAnimating()
	}

	func showAlert() {
		let alert = UIAlertController(title: "Upload failed", message: "error image not uploaded. Would you like to retry?", preferredStyle: UIAlertControllerStyle.Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		let retryAction = UIAlertAction(title: "Retry", style: .Default) { [weak self](alert) in
			self?.presenter.retryUpload()
		}
		alert.addAction(defaultAction)
		alert.addAction(retryAction)
		presentViewController(alert, animated: true, completion: nil)
	}

}

extension PostFeedController: PostFeedCellDelegate {
	func imageTapped(image: [String: AnyObject]) {
		self.navigationController?.pushViewController(MainAssembly.sharedInstance.getZoomPhotoController(image), animated: true)
	}
}

extension PostFeedController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(view.frame.width - 10, 150)
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 50
	}
}

extension PostFeedController: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostFeedCell
		if let image = images?[indexPath.item] {
			cell.setContent(image)
		}
		cell.delegate = self
		return cell
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images?.count ?? 0
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

}
