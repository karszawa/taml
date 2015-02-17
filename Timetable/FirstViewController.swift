//
//  FirstViewController.swift
//  Timetable
//
//  Created by Cubic on 2015/02/09.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import UIKit
import Realm

let TODAY = NSDate()
let PRIMARY_COLOR = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0)
let SUB_COLOR1 = UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1.0)
let SUB_COLOR2 = UIColor(red: 153/255, green: 170/255, blue: 181/255, alpha: 1.0)
let SUB_COLOR3 = UIColor(red: 204/255, green: 214/255, blue: 221/255, alpha: 1.0)
let SUB_COLOR4 = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1.0)

class FirstViewController: UIViewController {
	@IBOutlet weak var timetableView: PersistScrollView!
	var realm : RLMRealm?
	
	var exceptSubjects = [ "中国語", "フランス語" ]
	
	override func viewDidLoad() {
		super.viewDidLoad()

		realmSetSchema()
		
		realm = RLMRealm.defaultRealm()
		
		if Session.allObjects().count == 0 {
			if let url = NSURL(string: "http://www.akashi.ac.jp/data/timetable/timetable201410.xml") {
				self.loadFromWeb(url, myGrade: 4, myDepartment: "電気情報工学科", myCourse: "情報工学コース")
			}
		}
		
		self.timetableView.pageGenerator = {
			self.dateView(TODAY.succ(.DayCalendarUnit, value: $0)!)
		}
	}

//	override func viewDidLayoutSubviews() {
////		self.timetableView.contentSize.width = self.timetableView.frame.width * 3 // クソ
////		self.timetableView.adjustContentsPosition() // クソ
//	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}

	func dateView(date : NSDate) -> UIView {
		return DateTableView.instance(date, sessions: Session.objectsWhere("day = \(date.weekday() - 1)"))
	}
	
	func loadFromWeb(url : NSURL, myGrade : Int, myDepartment : String, myCourse : String?) {
		let xml = SWXMLHash.parse(NSData(contentsOfURL: url)!)
		
		for lecture in xml["TimeTable_xml"]["TimeTable"]["Lectures"]["Lecture"] {
			let name = lecture["Name"].element?.text
			var grade = lecture["Grade"].element?.text?.toInt()
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
				let dictionary = [
					"09:00:00+09:00": ["10:30:00+09:00" : [1], "12:10:00+09:00" : [1, 2]],
					"10:40:00+09:00": ["12:10:00+09:00" : [2]],
					"13:00:00+09:00": ["14:30:00+09:00" : [3], "16:10:00+09:00" : [3, 4]],
					"14:40:00+09:00": ["16:10:00+09:00" : [4]]
				]
				
				realm!.transactionWithBlock() {
					for p in dictionary[startTime!]![endTime!]! {
						var subject = Subject(title: name!, location: location!, deduction: 0.0)
						var session = Session(day: wday, period: p, subject: subject)
						subject.sessions.addObject(session)
						
						self.realm!.addOrUpdateObject(subject)
						self.realm!.addOrUpdateObject(session)
					}
				}
			}
		}
	}
	
	func longPressed(sender: UILongPressGestureRecognizer) {
		println("longPressed in Controller")
	}
	
	
	func realmSetSchema() {
		RLMRealm.setSchemaVersion(6, forRealmAtPath: RLMRealm.defaultRealmPath(),
			withMigrationBlock: { migration, oldSchemaVersion in
				migration.enumerateObjects(Session.className()) { oldObject, newObject in
					if oldSchemaVersion < 6 {
						
					}
				}
		})
	}
}
