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
			responder = responder?.nextResponder()? ?? self
			
			if responder == nil {
				return nil
			} else if responder!.isKindOfClass(UIViewController.self) {
				return responder as? UIViewController
			}
		}
	}
}


let CALENDAR = NSCalendar(identifier: NSGregorianCalendar)!

extension NSDate {
	func succ(unit : NSCalendarUnit, value : Int) -> NSDate? {
		return CALENDAR.dateByAddingUnit(unit, value: value, toDate: self, options: nil)
	}

	func weekday() -> Int {
		return CALENDAR.component(.WeekdayCalendarUnit, fromDate: self)
	}
	
	func month() -> Int {
		return CALENDAR.component(.MonthCalendarUnit, fromDate: self)
	}
	
	func day() -> Int {
		return CALENDAR.component(.DayCalendarUnit, fromDate: self)
	}
}

extension UIColor {
	class var PrimaryColor : UIColor { return UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0) }
	class var SubColor1 : UIColor { return UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1.0) }
	class var SubColor2 : UIColor { return UIColor(red: 153/255, green: 170/255, blue: 181/255, alpha: 1.0) }
	class var SubColor3 : UIColor { return UIColor(red: 204/255, green: 214/255, blue: 221/255, alpha: 1.0) }
	class var SubColor4 : UIColor { return UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1.0) }
}
