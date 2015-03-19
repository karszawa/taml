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

class FirstViewController: UIViewController {
	@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var messageLabelView: UILabel!
	@IBOutlet weak var timetableView: PersistScrollView!
	var realm : RLMRealm?
	var sessions = [[Session?]](count: 7, repeatedValue: [])
	var editable = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		realmSetSchema()
		
		realm = RLMRealm.defaultRealm()
		
		realm!.beginWriteTransaction()
		realm!.deleteObjects(Session.allObjects())
		realm!.commitWriteTransaction()
		
		if Session.allObjects().count == 0 {
			if let url = NSURL(string: "http://www.akashi.ac.jp/data/timetable/timetable201410.xml") {
				self.loadFromWeb(url, myGrade: 4, myDepartment: "電気情報工学科", myCourse: "情報工学コース")
			}
		}
		
		for rlmobject in Session.allObjects() {
			let session = rlmobject as Session
			while sessions[session.day - 1].count < session.period {
				sessions[session.day - 1].append(nil)
			}
			
			sessions[session.day - 1][session.period - 1] = session
		}
		
		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPushed:")
		]
		
		self.timetableView.pageGenerator = {
			let date = TODAY.succ(.DayCalendarUnit, value: $0)!
			return DateTableView.instance(date, sessions: self.sessions[date.weekday() - 1], editable: self.editable)
		}
		
		self.timetableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressed:") => {
			$0.minimumPressDuration = 1.0;
		})
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func loadFromWeb(url : NSURL, myGrade : Int, myDepartment : String, myCourse : String?) {
		let xml = SWXMLHash.parse(NSData(contentsOfURL: url)!)
		
		for lecture in xml["TimeTable_xml"]["TimeTable"]["Lectures"]["Lecture"] {
			let name = lecture["Name"].element?.text
			var grade = lecture["Grade"].element?.text?.toInt()
			let department = lecture["Department"].element!.text!
			let wday = lecture["Wday"].element!.text!.toInt()! + 1
			let location = lecture["Location"].element?.text
			let course = lecture["Course"].element?.text
			let startTime = lecture["StartTime"].element?.text
			let endTime = lecture["EndTime"].element?.text
			
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
	
	func realmSetSchema() {
		RLMRealm.setSchemaVersion(6, forRealmAtPath: RLMRealm.defaultRealmPath(),
			withMigrationBlock: { migration, oldSchemaVersion in
				migration.enumerateObjects(Session.className()) { oldObject, newObject in
					if oldSchemaVersion < 6 {
						self.realm!.transactionWithBlock() {
							self.realm!.addOrUpdateObject(Subject(title: "", location: "", deduction: 0))
						}
					}
				}
		})
	}
	
	func longPressed(sender: UILongPressGestureRecognizer) {
		if sender.state != UIGestureRecognizerState.Began {
			return
		}
		
		let currentTableView = self.timetableView.currentView as DateTableView
		let point = sender.locationInView(currentTableView)
		if let period = currentTableView.indexPathForRowAtPoint(point)?.row {
			let wday = currentTableView.date!.weekday()
			var session = sessions[wday - 1][period]

			var alert = UIAlertController(title: session!.subject.title, message: nil, preferredStyle: .ActionSheet)

			alert.addAction(UIAlertAction(title: "欠席(-1.0)", style: .Default, handler: { (action: UIAlertAction!) in
				self.realm!.transactionWithBlock() {
					session!.subject.deduction -= 1.0
				}
				
				currentTableView.reloadData()
			}))

			alert.addAction(UIAlertAction(title: "遅刻(-0.5)", style: .Default, handler: { (action: UIAlertAction!) in
				self.realm!.transactionWithBlock() {
					session!.subject.deduction -= 0.5
				}
				
				currentTableView.reloadData()
			}))
			
			alert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
			
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func editButtonPushed(sender: UIButton) {
		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonPushed:"),
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPushed:")
		]
		
		editable = true
		switchEditable(true)
	}
	
	func cancelButtonPushed(sender: UIButton) {
		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPushed:")
		]
		
		editable = false
		switchEditable(false)
	}
	
	func doneButtonPushed(sender: UIButton) {
		editable = false
		switchEditable(false)
	}
	
	func switchEditable(b : Bool) {
		for subview in self.timetableView.subviews {
			var s = subview as DateTableView
			s.editable = b
			s.reloadData()
		}
	}
}
