//
//  Subject.swift
//  Timetable
//
//  Created by Cubic on 2015/02/10.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import Realm

class Subject : RLMObject {
	dynamic var title = ""
	dynamic var location = ""
	dynamic var deduction = Float(0)
	
	override init() {
		super.init()
	}
	
	override init(object: AnyObject?) {
		super.init(object:object)
	}
	
	override init(object value: AnyObject!, schema: RLMSchema!) {
		super.init(object: value, schema: schema)
	}
	
	override init(objectSchema: RLMObjectSchema) {
		super.init(objectSchema: objectSchema)
	}
	
	init(title : String, location : String, deduction : Float) {
		super.init()

		self.title = title
		self.location = location
		self.deduction = deduction
	}
	
	override class func primaryKey() -> String {
		return "title"
	}
	
	class func find(title : String) -> Subject? {
		return Subject.objectsWithPredicate(NSPredicate(format: "title = %@", title)).firstObject() as? Subject
	}
}

class Session : RLMObject {
	dynamic var subject = Subject()
	dynamic var day : Int = 0 {
		didSet {
			self.key = day.description + " " + period.description
		}
	}
	dynamic var period : Int = 0 {
		didSet {
			self.key = day.description + " " + period.description
		}
	}
	dynamic var key = ""
	
	override init() {
		super.init()
	}
	
	override init(object: AnyObject?) {
		super.init(object:object)
	}
	
	override init(object value: AnyObject!, schema: RLMSchema!) {
		super.init(object: value, schema: schema)
	}
	
	override init(objectSchema: RLMObjectSchema) {
		super.init(objectSchema: objectSchema)
	}
	
	init(day : Int, period : Int, subject : Subject) {
		super.init()
		
		self.day = day
		self.period = period
		self.subject = subject
		self.key = day.description + " " + period.description
	}
	
	override class func primaryKey() -> String {
		return "key"
	}
	
	class func find(day : Int, period : Int) -> Session? {
		return Session.objectsWithPredicate(NSPredicate(format: "key = '\(day) \(period)'")).firstObject() as? Session
	}
}

