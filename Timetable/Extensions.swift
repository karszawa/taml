//
//  Extensions.swift
//  Timetable
//
//  Created by Cubic on 2015/02/14.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

infix operator => { associativity left precedence 91 }

func => <T>(object: T, initializer: (T) -> ()) -> T {
	initializer(object)
	return object
}

extension UIView {
	func getParentViewController() -> UIViewController? {
		var responder : UIResponder? = self
		while true {
			responder = responder?.nextResponder() ?? self
			
			if responder == nil {
				return nil
			} else if responder!.isKindOfClass(UIViewController.self) {
				return responder as? UIViewController
			}
		}
	}
	
	func getFirstResponder() -> UIView? {
		if self.isFirstResponder() {
			return self
		}
		
		for subview in self.subviews {
			if subview.isFirstResponder() {
				return subview as? UIView
			}
			
			if let ret = subview.getFirstResponder() {
				return ret
			}
		}
		
		return nil
	}
	
	func absPoint() -> CGPoint {
		if self.superview == nil {
			return CGPointZero
		}
		
		var p = self.superview!.absPoint()
		return CGPoint(x: self.frame.origin.x + p.x, y: self.frame.origin.y + p.y)
	}
}

extension String {
	var floatValue: Float {
		return (self as NSString).floatValue
	}
}

let CALENDAR = NSCalendar(identifier: NSCalendarIdentifierGregorian)!

extension NSDate {
	func succ(unit : NSCalendarUnit, value : Int) -> NSDate? {
		return CALENDAR.dateByAddingUnit(unit, value: value, toDate: self, options: nil)
	}

	func weekday() -> Int {
		return CALENDAR.component(.CalendarUnitWeekday, fromDate: self)
	}
	
	func month() -> Int {
		return CALENDAR.component(.CalendarUnitMonth, fromDate: self)
	}
	
	func day() -> Int {
		return CALENDAR.component(.CalendarUnitDay, fromDate: self)
	}
}

extension UIColor {
	class var PrimaryColor : UIColor { return UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0) }
	class var SubColor1 : UIColor { return UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1.0) }
	class var SubColor2 : UIColor { return UIColor(red: 153/255, green: 170/255, blue: 181/255, alpha: 1.0) }
	class var SubColor3 : UIColor { return UIColor(red: 204/255, green: 214/255, blue: 221/255, alpha: 1.0) }
	class var SubColor4 : UIColor { return UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1.0) }
}

extension NSCalendar {
	class var Weekdays : [String] { return [ "", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日" ] }
	//class var Weekdays : [String] { return [ "", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ] }
	class var Months : [String] { return [ "", "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec." ] }
}
