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

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		setDelegates()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	func setupViews() {
		view.backgroundColor = UIColor.whiteColor()
		collectionView = UICollectionView(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
		collectionView.registerClass(PostFeedCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.addPullToRefreshWithActionHandler { [weak self] in
			self?.presenter.refreshData()
		}

		collectionView.addInfiniteScrollingWithActionHandler { [weak self] in
			self?.presenter.loadNew()
		}

		collectionView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
		view.addSubview(collectionView)
	}

	func setupConstraints() {
		collectionView.snp_makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			make.top.equalTo(30)
			make.bottom.equalTo(self.view)
		}
	}

	func setDelegates() {
		collectionView.delegate = self
		collectionView.dataSource = self
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
}

extension PostFeedController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		// full screen image with pinch to zoom
	}

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
		cell.setContent(images![indexPath.item])
		return cell
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images?.count ?? 0
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

}
