//
//  FeedbackSettingCell.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackSettingCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet weak var feedbackField: UITextViewX!
	@IBOutlet weak var submitButton: UIButtonX!
	
	func build() {
		feedbackField.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		feedbackField.delegate = self
		feedbackField.textColor = UIColor(named: "lightGray")!
		submitButton.setTitle("Thank you!", for: .disabled)
		submitButton.setTitleColor(UIColor(named: "gray"), for: .disabled)
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		IQKeyboardManager.shared.enable = true
		
		if feedbackField.textColor == UIColor(named: "lightGray") {
			feedbackField.text = nil
			feedbackField.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if feedbackField.text.isEmpty {
			feedbackField.text = "If you have any thoughts about your Hour Blocks experience, let me know here!"
			feedbackField.textColor = UIColor(named: "lightGray")
		}
	}
	
	@IBAction func submitPressed(_ sender: Any) {
		if !feedbackField.text.isEmpty {
			UIImpactFeedbackGenerator().impactOccurred()
			IQKeyboardManager.shared.enable = false
			AnalyticsGateway.shared.logFeedback(with: feedbackField.text)
			submitButton.isEnabled = false
			submitButton.backgroundColor = UIColor(named: "mainLight")
			feedbackField.isHidden = true
			feedbackField.text = ""
		}
	}
	
	@IBAction func followTwitterPressed(_ sender: Any) {
		UIApplication.shared.open(URL(string: "twitter://user?screen_name=j_t_saeed")!, options: [:], completionHandler: nil)
	}
}
