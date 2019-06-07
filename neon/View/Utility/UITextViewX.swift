//
//  UIViewX.swift
//  DesignableX
//
//  Created by Mark Moeykens on 12/31/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UITextViewX: UITextView {
	
	// MARK: - Border
	
	@IBInspectable public var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
			layer.masksToBounds = cornerRadius > 0
		}
	}
	
	@IBInspectable public var borderColor: UIColor = UIColor.clear {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable public var borderWidth: CGFloat = 0 {
		didSet {
			layer.borderWidth = borderWidth
		}
	}
}
