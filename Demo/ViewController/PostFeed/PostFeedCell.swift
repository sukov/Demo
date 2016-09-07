//
//  PostFeedCell.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import UIKit
import Haneke

class PostFeedCell: UICollectionViewCell {
	private var titleLabel: UILabel = UILabel()
	private var descriptionText: UITextView = UITextView()
	private var imageView: UIImageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()
		addSubview(titleLabel)
		addSubview(descriptionText)
		addSubview(imageView)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupConstraints() {
		titleLabel.snp_makeConstraints { (make) in
			make.left.right.equalTo(self)
			make.top.equalTo(5)
			make.height.equalTo(20)
		}
		imageView.snp_makeConstraints { (make) in
			make.left.right.equalTo(self)
			make.top.equalTo(titleLabel.snp_bottom).offset(10)
			make.height.equalTo(80)
		}
		descriptionText.snp_makeConstraints { (make) in
			make.left.right.equalTo(self)
			make.top.equalTo(imageView.snp_bottom).offset(5)
			make.height.equalTo(50)
		}
	}

	func setContent(image: [String: AnyObject]) {
		titleLabel.text = image["title"] as? String ?? ""
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.layoutIfNeeded()
		imageView.hnk_setImageFromURL(NSURL(string: image["link"] as? String ?? "")!)
		descriptionText.text = image["description"] as? String ?? ""
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		titleLabel.text = ""
		imageView.hnk_cancelSetImage()
		descriptionText.text = ""
	}

}
