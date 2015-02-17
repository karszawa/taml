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
			var newPage = pageGenerator!(currentPageNumber + i) as DateTableView => {
				$0.frame.size = self.frame.size
				$0.frame.origin.x = self.frame.width * CGFloat(i)
			}
			
			self.addSubview(newPage)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.contentSize.width = self.frame.width * 3
		self.adjustContentsPosition()
	}
}
