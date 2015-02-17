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
		return CALENDAR.dateByAddingUnit(.DayCalendarUnit, value: value, toDate: self, options: nil)
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
