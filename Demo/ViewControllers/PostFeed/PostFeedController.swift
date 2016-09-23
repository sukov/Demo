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
	private var posts: [[String: AnyObject]]?
	private let cellID = "postFeedCellID"

	init(presenter: PostFeedPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		presenter.detachView(self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.attachView(self)
		setupViews()
		setupNavigationBar()
		setupConstraints()
		setDelegates()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

	}

	func setupNavigationBar() {
		let revealBtn = UIButton()
		revealBtn.setImage(UIImage(named: ImageNames.revealIcon), forState: .Normal)
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
		floatingButton.setImage(UIImage(named: ImageNames.floatingBtn), forState: UIControlState.Normal)
		floatingButton.addTarget(self, action: #selector(floatingButtonTapped), forControlEvents: .TouchUpInside)
		collectionView.registerClass(PostFeedCell.self, forCellWithReuseIdentifier: cellID)
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

	func returnedFromBackground() {
		presenter.refreshData()
	}

	func floatingButtonTapped() {
		navigationController?.pushViewController(MainAssembly.sharedInstance.getCreatePostController(), animated: true)
	}
}

extension PostFeedController: PostFeedView {
	func showPosts(posts: [[String: AnyObject]]) {
		self.posts = posts
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

	func showRetryAlert() {
		presentViewController(AlertFactory.retryUpload(), animated: true, completion: nil)
	}

	func showSettingsAlert() {
		presentViewController(AlertFactory.settings(), animated: true, completion: nil)
	}

	func scrollToTop() {
		collectionView.setContentOffset(CGPointZero, animated: true)
	}
}

extension PostFeedController: PostFeedCellDelegate {
	func imageTapped(imageUrl: NSURL, imageSize: CGSize) {
		self.navigationController?.pushViewController(MainAssembly.sharedInstance.getZoomPhotoController(
			imageUrl,
			imageSize: imageSize),
			animated: true)
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
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PostFeedCell
		if let image = posts?[indexPath.item] {
			cell.setContent(image)
		}
		cell.delegate = self
		return cell
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts?.count ?? 0
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

}
