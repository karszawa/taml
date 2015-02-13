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

	init(frame : CGRect, pageGenerator : (Int) -> UIView) {
		self.pageGenerator = pageGenerator
		super.init(frame: frame)
		self.pagingEnabled = true
		self.showsHorizontalScrollIndicator = false;
		self.showsVerticalScrollIndicator = false;
		self.contentSize.width = frame.width * 3
		self.contentOffset.x = frame.width
		self.delegate = self
		
		self.correctContentsPosition(self.currentPageNumber)
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let displacement = scrollView.contentOffset.x / frame.width - 1
		
		if abs(displacement) < 1 {
			return
		}
		
		self.currentPageNumber += Int(displacement)
		self.correctContentsPosition(self.currentPageNumber)
		self.contentOffset.x = frame.width
	}
	
	func correctContentsPosition(index : Int) {
		for subview in subviews {
			subview.removeFromSuperview()
		}
		
		for i in 0...2 {
			var newPage = pageGenerator!(currentPageNumber + i - 1)
			newPage.frame.origin.x = newPage.frame.width * CGFloat(i)
			self.addSubview(newPage)
		}
	}
}
