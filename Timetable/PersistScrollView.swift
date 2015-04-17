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
	var pageGenerator : ((Int) -> UIView)?
	var currentPageNumber = 0
	var currentView : UIView {
		return self.subviews[1] as UIView
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		self.delegate = self
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let displacement = scrollView.contentOffset.x / frame.width - 1
		
		println(displacement)
		if abs(displacement) >= 1 {
			self.currentPageNumber += Int(displacement)
			self.reloadContents()
			self.contentOffset.x = frame.width
		}
	}
	
	func reloadContents() {
		for subview in subviews {
			subview.removeFromSuperview()
		}
		
		for i in 0...2 {
			let newPage = (pageGenerator!(currentPageNumber + i - 1) as DateTableView)
			newPage.frame.size = self.frame.size
			newPage.frame.origin.x = self.frame.width * CGFloat(i)
			self.addSubview(newPage)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// if resised
		if self.contentSize.width != self.frame.width * 3 {
			self.contentSize.width = self.frame.width * 3
			self.contentOffset.x = self.frame.width
			self.reloadContents()
		}
	}
}
