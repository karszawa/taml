//
//  PersistScrollView.swift
//  Timetable
//
//  Created by Cubic on 2015/02/09.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

class PersistScrollView : UIScrollView, UIScrollViewDelegate {
	var pageGenerator : ((Int) -> UIView)? {
		didSet {
			self.adjustContentsPosition()
		}
	}
	
	var currentPageNumber = 0

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		self.delegate = self
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let displacement = scrollView.contentOffset.x / frame.width - 1
		
		if abs(displacement) < 1 {
			return
		}
		
		self.currentPageNumber += Int(displacement)
		self.adjustContentsPosition()
		self.contentOffset.x = frame.width
	}
	
	func adjustContentsPosition() {
		for subview in subviews {
			subview.removeFromSuperview()
		}
		
		for i in 0...2 {
			var newPage = pageGenerator!(currentPageNumber + i - 1) as DateTableView => {
				$0.frame.size = self.frame.size
				$0.frame.origin.x = self.frame.width * CGFloat(i)
			}
			
			self.addSubview(newPage)
//			self.addConstraint(NSLayoutConstraint(item: newPage, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
		}
		
//		self.subviews[1].addConstraints([
//			NSLayoutConstraint(item: self.subviews[0], attribute: .Right, relatedBy: .Equal, toItem: self.subviews[1], attribute: .Left, multiplier: 1, constant: 0),
//			NSLayoutConstraint(item: self.subviews[2], attribute: .Left, relatedBy: .Equal, toItem: self.subviews[1], attribute: .Right, multiplier: 1, constant: 0)
//		])
	}
}
