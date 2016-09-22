//
//  PostFeedCell.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import UIKit
import SDWebImage

class PostFeedCell: UICollectionViewCell {
	private var titleLabel: UILabel = UILabel()
	private var descriptionText: UITextView = UITextView()
	private var imageView: UIImageView = UIImageView()
	private var post: [String: AnyObject]?
	weak var delegate: PostFeedCellDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupViews() {
		backgroundColor = UIColor.whiteColor()
		descriptionText.userInteractionEnabled = false
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
		imageView.userInteractionEnabled = true
		imageView.addGestureRecognizer(tapGestureRecognizer)
		addSubview(titleLabel)
		addSubview(descriptionText)
		addSubview(imageView)
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

	func imageTapped() {
		if let link = post?[PostKeys.imageLink] as? String,
			width = post?[PostKeys.width] as? CGFloat,
			height = post?[PostKeys.height] as? CGFloat {
				if let url = NSURL(string: link) {
					delegate?.imageTapped(url, imageSize: CGSizeMake(width, height))
				}
		}
	}

	func setContent(post: [String: AnyObject]) {
		self.post = post
		titleLabel.text = post[PostKeys.title] as? String ?? ""
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.layoutIfNeeded()
		if let url = NSURL(string: post[PostKeys.imageLink] as? String ?? "") {
			imageView.sd_setImageWithURL(url)
		}
		descriptionText.text = post[PostKeys.description] as? String ?? ""
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		titleLabel.text = ""
		imageView.sd_cancelCurrentImageLoad()
		descriptionText.text = ""
	}

}

@objc protocol PostFeedCellDelegate {
	func imageTapped(imageUrl: NSURL, imageSize: CGSize)
}
