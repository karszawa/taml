//
//  Subject.swift
//  Timetable
//
//  Created by Cubic on 2015/02/10.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation

class Subject : NSObject, NSCoding {
	internal let title : String?
	internal let location : String?
	internal let period : String?
	internal var deduction : Float
	
	init(title : String?, location : String?, period : Int, deduction : Float) {
		self.title = title
		self.location = location
		self.period = period.description + " 限"
		self.deduction = deduction
		super.init()
	}
	
	required init(coder aDecoder: NSCoder) {
		self.title = aDecoder.decodeObjectForKey("TITLE") as? String
		self.location = aDecoder.decodeObjectForKey("LOCATION") as? String
		self.period = aDecoder.decodeObjectForKey("PERIOD") as? String
		self.deduction = aDecoder.decodeFloatForKey("DEDUCTION")
		super.init()
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.title?, forKey: "TITLE")
		aCoder.encodeObject(self.location?, forKey: "LOCATION")
		aCoder.encodeObject(self.period?, forKey: "PERIOD")
		aCoder.encodeFloat(self.deduction, forKey: "DEDUCTION")
	}
}