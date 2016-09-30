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
	static let titleFontSize: CGFloat = 17
	static let descriptionFontSize: CGFloat = 12

	private var titleLabel: UILabel = UILabel()
	private var descriptionLabel: UILabel = UILabel()
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

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		titleLabel.text = ""
		imageView.sd_cancelCurrentImageLoad()
		descriptionLabel.text = ""
	}

	func setupViews() {
		backgroundColor = UIColor.whiteColor()

		titleLabel.lineBreakMode = .ByWordWrapping
		titleLabel.numberOfLines = 0
		titleLabel.font.fontWithSize(PostFeedCell.titleFontSize)
		descriptionLabel.lineBreakMode = .ByWordWrapping
		descriptionLabel.numberOfLines = 0
		descriptionLabel.font = descriptionLabel.font.fontWithSize(PostFeedCell.descriptionFontSize)
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
		imageView.userInteractionEnabled = true
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.addGestureRecognizer(tapGestureRecognizer)

		addSubview(titleLabel)
		addSubview(descriptionLabel)
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
			make.height.equalTo(100)
		}
		descriptionLabel.snp_makeConstraints { (make) in
			make.left.right.equalTo(self)
			make.top.equalTo(imageView.snp_bottom).offset(5)
			make.height.equalTo(15)
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
		descriptionLabel.text = post[PostKeys.description] as? String ?? ""

		if let url = NSURL(string: post[PostKeys.imageLink] as? String ?? "") {
			imageView.sd_setImageWithURL(url)
		}
		updateSnpConstraints()
	}

	func updateSnpConstraints() {
		titleLabel.snp_updateConstraints(closure: { (make) in
			make.height.equalTo(PostFeedCell.calculateFontHeight(titleLabel.text!, fontSize: titleLabel.font.pointSize))
			}
		)

		if let imgHeight = post?[PostKeys.height] as? CGFloat, imgWidth = post?[PostKeys.width] as? CGFloat {
			var reducer = imgWidth / frame.width
			reducer = (reducer > 1) ? reducer : 1
			imageView.snp_updateConstraints(closure: { (make) in
				make.height.equalTo(imgHeight / reducer)
			})
		}

		descriptionLabel.snp_updateConstraints(closure: { (make) in
			make.height.equalTo(PostFeedCell.calculateFontHeight(descriptionLabel.text!, fontSize: descriptionLabel.font.pointSize))
			}
		)
	}

	static func heightOfFont (string: String, constrainedToWidth width: Double = Double(UIScreen.mainScreen().bounds.width), fontSize: CGFloat) -> CGFloat {
		return NSString(string: string).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
			options: [.UsesLineFragmentOrigin, .UsesFontLeading],
			attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)],
			context: nil).size.height
	}

	func sizeOfString (string: String, constrainedToHeight height: Double) -> CGSize {
		return NSString(string: string).boundingRectWithSize(CGSize(width: DBL_MAX, height: height),
			options: [.UsesLineFragmentOrigin, .UsesFontLeading],
			attributes: [NSFontAttributeName: self],
			context: nil).size
	}

	static func calculateFontHeight(text: String, fontSize: CGFloat) -> CGFloat {
		let maxLineCharacters = (UIScreen.mainScreen().bounds.width / fontSize) * 1.95
		let fontHeight = fontSize + 7
		return ceil(CGFloat(text.characters.count) / maxLineCharacters) * fontHeight
	}

	static func getCellHeightFromPost(post: [String: AnyObject]) -> CGFloat {
		var cellHeight: CGFloat = 0
		let titileHeight = calculateFontHeight((post[PostKeys.title] as? String ?? ""), fontSize: PostFeedCell.titleFontSize)
		let descriptionHeight = calculateFontHeight((post[PostKeys.description] as? String ?? ""), fontSize: PostFeedCell.descriptionFontSize)
		let constraintOffsets: CGFloat = 20

		if let imgHeight = post[PostKeys.height] as? CGFloat, imgWidth = post[PostKeys.width] as? CGFloat {
			var reducer = imgWidth / UIScreen.mainScreen().bounds.width
			reducer = (reducer > 1) ? reducer : 1
			cellHeight += imgHeight / reducer
		}
		cellHeight += titileHeight + descriptionHeight + constraintOffsets
		return cellHeight
	}
}

@objc protocol PostFeedCellDelegate {
	func imageTapped(imageUrl: NSURL, imageSize: CGSize)
}
