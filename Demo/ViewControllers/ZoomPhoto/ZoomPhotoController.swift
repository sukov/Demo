//
//  ZoomPhotoController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/9/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import UIKit

class ZoomPhotoController: BaseViewController {
	private var presenter: ZoomPhotoPresenter
	private var imageScrollView: ImageScrollView!

	init(presenter: ZoomPhotoPresenter) {
		self.presenter = presenter
		super.init()
	}

	deinit {
		presenter.detachView(self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.attachView(self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setupViews() {
		super.setupViews()

		view.backgroundColor = UIColor.whiteColor()

		imageScrollView = ImageScrollView(frame: view.frame)
		imageScrollView.backgroundColor = UIColor.whiteColor()

		view.addSubview(imageScrollView)
	}

	override func setupConstraints() {
		super.setupConstraints()

		imageScrollView.snp_makeConstraints { (make) in
			make.left.right.bottom.equalTo(self.view)
			make.top.equalTo(view).offset(60)
		}
	}
}

extension ZoomPhotoController: ZoomPhotoView {
	func showImage(url: NSURL, size: CGSize) {
		imageScrollView.displayImage(url, imageSize: size)
	}
}
