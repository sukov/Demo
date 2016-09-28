//
//  CreatePostController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/12/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class CreatePostController: BaseViewController, CreatePostView {
	private var presenter: CreatePostPresenter
	private var imagePicker: UIImagePickerController!
	private var cancelPostButton: UIButton!
	private var submitPostButton: UIButton!
	private var selectImageButton: UIButton!
	private var takePhotoButton: UIButton!
	private var selectedImageView: UIImageView!
	private var postTitle: UITextField!
	private var postDescription: UITextField!

	init(presenter: CreatePostPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	override func setupViews() {
		super.setupViews()

		view.backgroundColor = UIColor.whiteColor()

		imagePicker = UIImagePickerController()
		imagePicker.delegate = self

		selectedImageView = UIImageView()
		selectedImageView.layer.borderWidth = 1
		selectedImageView.layer.borderColor = UIColor.grayColor().CGColor

		postTitle = UITextField()
		postTitle.attributedPlaceholder = NSAttributedString(string: "Title",
			attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
		postTitle.delegate = self

		postDescription = UITextField()
		postDescription.attributedPlaceholder = NSAttributedString(string: "Description",
			attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
		postDescription.delegate = self

		submitPostButton = UIButton()
		submitPostButton.customBlueButton("Post")
		submitPostButton.addTarget(self, action: #selector(submitPostButtonTapped), forControlEvents: .TouchUpInside)

		cancelPostButton = UIButton()
		cancelPostButton.customBlueButton("Cancel")
		cancelPostButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)

		selectImageButton = UIButton()
		selectImageButton.customBlueButton("Select image")
		selectImageButton.layer.cornerRadius = 5
		selectImageButton.addTarget(self, action: #selector(selectImageButtonTapped), forControlEvents: .TouchUpInside)

		takePhotoButton = UIButton()
		takePhotoButton.customBlueButton("Take photo")
		takePhotoButton.layer.cornerRadius = 5
		takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), forControlEvents: .TouchUpInside)

		view.addSubview(submitPostButton)
		view.addSubview(cancelPostButton)
		view.addSubview(takePhotoButton)
		view.addSubview(selectImageButton)
		view.addSubview(selectedImageView)
		view.addSubview(postTitle)
		view.addSubview(postDescription)
	}

	override func setupConstraints() {
		super.setupConstraints()

		selectedImageView.snp_makeConstraints { (make) in
			make.left.equalTo(self.view)
			make.right.equalTo(self.view)
			make.top.equalTo(self.view).offset(65)
			make.height.equalTo(self.view.frame.height / 4)
		}

		selectImageButton.snp_makeConstraints { (make) in
			make.left.equalTo(self.view).offset(20)
			make.width.equalTo(120)
			make.top.equalTo(selectedImageView.snp_bottom).offset(20)
			make.height.equalTo(30)
		}

		takePhotoButton.snp_makeConstraints { (make) in
			make.left.equalTo(selectImageButton.snp_right).offset(30)
			make.top.equalTo(selectImageButton.snp_top)
			make.width.equalTo(120)
			make.height.equalTo(30)
		}

		postTitle.snp_makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			make.top.equalTo(selectedImageView.snp_bottom).offset(75)
		}

		postDescription.snp_makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			make.top.equalTo(postTitle.snp_bottom).offset(25)
		}

		cancelPostButton.snp_makeConstraints { (make) in
			make.left.equalTo(self.view)
			make.top.equalTo(postDescription.snp_bottom).offset(30)
			make.width.equalTo(self.view.frame.width / 3)
			make.height.equalTo(40)
		}

		submitPostButton.snp_makeConstraints { (make) in
			make.right.equalTo(self.view.snp_right)
			make.top.equalTo(postDescription.snp_bottom).offset(30)
			make.width.equalTo(self.view.frame.width / 3)
			make.height.equalTo(40)
		}
	}

	func cancelButtonTapped() {
		navigationController?.popViewControllerAnimated(true)
	}

	func submitPostButtonTapped() {
		if let img = selectedImageView.image {
			presenter.postSubmit(img, title: postTitle?.text ?? "", description: postDescription?.text ?? "")
		}
		navigationController?.popViewControllerAnimated(true)
	}

	func selectImageButtonTapped() {
		if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)) {
			if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.Authorized {
				// Already Authorized
				imagePicker.sourceType = .PhotoLibrary
				presentViewController(imagePicker, animated: true, completion: nil)
			} else {
				AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self](granted: Bool) -> Void in
					if granted == true {
						// User granted
						if let _self = self {
							_self.imagePicker.sourceType = .PhotoLibrary
							_self.presentViewController(_self.imagePicker, animated: true, completion: nil)
						}
					} else {
						// User Rejected
					}
				});
			}
		}
	}

	func takePhotoButtonTapped() {
		if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
			if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.Authorized {
				// Already Authorized
				imagePicker.sourceType = .Camera
				presentViewController(imagePicker, animated: true, completion: nil)
			} else {
				AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self](granted: Bool) -> Void in
					if granted == true {
						// User granted
						if let _self = self {
							_self.imagePicker.sourceType = .Camera
							_self.presentViewController(_self.imagePicker, animated: true, completion: nil)
						}
					} else {
						// User Rejected
					}
				});
			}
		}
	}
}

@objc protocol CreatePostView {
}

extension CreatePostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
		selectedImageView.image = image
		dismissViewControllerAnimated(true, completion: nil)
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

extension CreatePostController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
