
import Foundation

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

var d = NSDate()
d.succ(NSCalendarUnit.CalendarUnitDay, value: 3)!.weekday()

