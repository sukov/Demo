//
//  ZoomPhotoController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/9/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import UIKit
import Haneke

class ZoomPhotoController: UIViewController {
	private var presenter: ZoomPhotoPresenter
	private var imageScrollView: ImageScrollView!

	init(presenter: ZoomPhotoPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupViews() {
		imageScrollView = ImageScrollView(frame: view.frame)
		imageScrollView.backgroundColor = UIColor.whiteColor()
		view.addSubview(imageScrollView)
	}

	func setupConstraints() {
		imageScrollView.snp_makeConstraints { (make) in
			make.left.right.bottom.equalTo(self.view)
			make.top.equalTo(self.view).offset(20)
		}

	}
}

extension ZoomPhotoController: ZoomPhotoView {
	func showPicture(image: [String: AnyObject]) {
		if let imageLink = NSURL(string: image["link"] as? String ?? "") {
			let imageSize = CGSizeMake(image["width"] as? CGFloat ?? 200, image["height"] as? CGFloat ?? 200)
			imageScrollView.displayImage(imageLink, imageSize: imageSize)
		}
	}
}
