//
//  FirstViewController.swift
//  Timetable
//
//  Created by Cubic on 2015/02/09.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	var startDate = NSDate()
	let calendar = NSCalendar(identifier: NSGregorianCalendar)!
	var timetableView: PersistScrollView!
	
	var subjects = [[Subject]](count: 7, repeatedValue: [Subject]())
	var exceptSubjects = [ "中国語", "フランス語" ]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let s = readDB() {
			subjects = s
		} else {
			println("Read from WEB")
			let url = NSURL(string: "http://www.akashi.ac.jp/data/timetable/timetable201410.xml")!
			subjects = readXML(url, myGrade: 4, myDepartment: "電気情報工学科", myCourse: "情報工学コース")
		}
		
		timetableView = PersistScrollView(frame: self.view.bounds, newPageGenerator : {
			self.dateView(self.calendar.dateByAddingUnit(.DayCalendarUnit, value: $0, toDate: self.startDate, options: nil)!)
		})
		
		self.view.addSubview(self.timetableView!)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	required init(coder aDecoder: NSCoder) {
		println("readDB")
		super.init(coder: aDecoder)
	}
	
	override func viewDidDisappear(animated: Bool) {
		println("saveDB")
		saveDB()
		super.viewDidDisappear(animated)
	}

	func dateView(date : NSDate) -> UIView {
		let day = calendar.component(.WeekdayCalendarUnit, fromDate: date) - 1
		return DatetableView(frame: self.view.bounds, date: date, subjcets: &(subjects[day]), parentViewController: self)
	}
	
	func readDB() -> [[Subject]]? {
		let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
		let path = paths[0].stringByAppendingPathComponent("sample.dat")
		
		return (NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [[Subject]])
	}
	
	func saveDB() -> Bool {
		let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
		let path = paths[0].stringByAppendingPathComponent("sample.dat")
		
		return NSKeyedArchiver.archiveRootObject(self.subjects, toFile: path)
	}
	
	func readXML(url : NSURL, myGrade : Int, myDepartment : String, myCourse : String?) -> [[Subject]] {
		var subjects = [[Subject]](count: 7, repeatedValue: [Subject]())
		let xml = SWXMLHash.parse(NSData(contentsOfURL: url)!)
		var prevGrade = 0 // Gradeが未入力の項目がある
		
		for lecture in xml["TimeTable_xml"]["TimeTable"]["Lectures"]["Lecture"] {
			let name = lecture["Name"].element?.text
			var grade = lecture["Grade"].element?.text?.toInt() ?? prevGrade
			let department = lecture["Department"].element!.text!
			let wday = lecture["Wday"].element!.text!.toInt()!
			let location = lecture["Location"].element?.text
			let course = lecture["Course"].element?.text
			let startTime = lecture["StartTime"].element?.text
			let endTime = lecture["EndTime"].element?.text
			
			if contains(exceptSubjects, { $0 == name }) {
				continue
			}
			
			if grade == myGrade && department == myDepartment && course == myCourse {
				if startTime == "09:00:00+09:00" && endTime == "12:10:00+09:00" {
					subjects[wday].append(Subject(title: name, location: location, period: 1, deduction: 0))
					subjects[wday].append(Subject(title: name, location: location, period: 2, deduction: 0))
				} else if startTime == "13:00:00+09:00" && endTime == "16:10:00+09:00" {
					subjects[wday].append(Subject(title: name, location: location, period: 3, deduction: 0))
					subjects[wday].append(Subject(title: name, location: location, period: 4, deduction: 0))
				} else {
					let dic = ["09:00:00+09:00": 1, "10:40:00+09:00": 2, "13:00:00+09:00": 3, "14:40:00+09:00": 4]
					subjects[wday].append(Subject(title: name, location: location, period: dic[startTime!]!, deduction: 0))
				}
			}
			
			prevGrade = grade
		}
		
		return subjects
	}
}
