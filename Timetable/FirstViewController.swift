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
		self.realm!.transactionWithBlock() {
			self.realm!.addOrUpdateObject(Subject(title: "", location: "", deduction: 0))
		}

		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPushed:")
		]
		
		self.timetableView.pageGenerator = {
			let date = TODAY.succ(.CalendarUnitDay, value: $0)!
			let deleteAction = { (inout ss : [Session?], it : Int) -> Void in
				self.realm!.transactionWithBlock() {
					self.realm!.deleteObject(ss[it])
					ss.removeAtIndex(it)

					for i in it ..< ss.count {
						ss[i]?.period -= 1
					}
				}
			}
			
			var sessions = [Session?]()
			for s in Session.objectsWhere("day = \(date.weekday())") {
				sessions.append(s as? Session)
			}
			
			sessions.sort({ ($0)?.period < ($1)?.period })
			
			return DateTableView.instance(date, sessions: sessions, deleteAction: deleteAction) => {
				$0.setEditing(self.editing, animated: false)
			}
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
	
	var isObserving = false
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if(!isObserving) {
			let notification = NSNotificationCenter.defaultCenter()
			notification.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
			notification.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
			isObserving = true
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		if(isObserving) {
			let notification = NSNotificationCenter.defaultCenter()
			notification.removeObserver(self)
			notification.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
			notification.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
			isObserving = false
		}
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
						
						self.realm!.addOrUpdateObject(subject)
						self.realm!.addOrUpdateObject(session)
					}
				}
			}
		}
	}
	
	func longPressed(sender: UILongPressGestureRecognizer) {
		if sender.state != UIGestureRecognizerState.Began {
			return
		}
		
		let currentTableView = self.timetableView.currentView as! DateTableView
		let point = sender.locationInView(currentTableView)
		if let period = currentTableView.indexPathForRowAtPoint(point)?.row {
			let wday = currentTableView.date!.weekday()
			var session = Session.objectsWhere("day = \(wday - 1) AND period = \(period)").firstObject() as! Session
			var alert = UIAlertController(title: session.subject.title, message: nil, preferredStyle: .ActionSheet)

			alert.addAction(UIAlertAction(title: "欠席(-1.0)", style: .Default, handler: { (action: UIAlertAction!) in
				self.realm!.transactionWithBlock() {
					session.subject.deduction -= 1.0
				}
				
				currentTableView.reloadData()
			}))

			alert.addAction(UIAlertAction(title: "遅刻(-0.5)", style: .Default, handler: { (action: UIAlertAction!) in
				self.realm!.transactionWithBlock() {
					session.subject.deduction -= 0.5
				}
				
				currentTableView.reloadData()
			}))
			
			alert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
			
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func editButtonPushed(sender: UIButton) {
		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPushed:"),
			UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPushed:")
		]
		
		setEditing(true, animated: true)
	}
	
	func doneButtonPushed(sender: UIButton) {
		toolBar.items = [
			UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPushed:")
		]

		setEditing(false, animated: true)
	}
	
	func addButtonPushed(sender: UIButton) {
		var view = (self.timetableView.currentView as! DateTableView)
		let period = view.numberOfRowsInSection(0)
		let newIndexPath = NSIndexPath(forRow: period, inSection: 0)
		let session = Session(day: view.date!.weekday(), period: period + 1, subject: Subject.find("")!)
		
		self.realm!.transactionWithBlock() {
			self.realm!.addOrUpdateObject(session)
		}
		
		view.sessions.append(session)
		view.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
	}
	
	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		for subview in self.timetableView.subviews {
			subview.setEditing(editing, animated: animated)
		}
	}
	
	func keyboardWillShow(notification: NSNotification?) {
		let keyboardY = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().minY
		if let textField = self.view.getFirstResponder() {
			let textFieldY = textField.absPoint().y + textField.frame.height
			let offsetY = textFieldY - min(keyboardY, textFieldY)
		
			(self.timetableView.currentView as! DateTableView).setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
		}
		
		self.timetableView.scrollEnabled = false
	}
	
	func keyboardWillHide(notification: NSNotification?) {
		let currentTableView = self.timetableView.currentView as! DateTableView
		if currentTableView.numberOfRowsInSection(0) == 0 {
			return
		}

		for i in 0 ..< currentTableView.numberOfRowsInSection(0) {
			if let cell = currentTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? SessionCell {
				realm?.transactionWithBlock() {
					var subject = Subject(title: cell.titleTextField.text, location: cell.locationTextField.text, deduction: cell.deductionTextField.text.floatValue)
					var wday = (self.timetableView.currentView as! DateTableView).date?.weekday()
					var session = Session(day: wday!, period: i+1, subject: subject)
					
					self.realm?.addOrUpdateObject(subject)
					self.realm?.addOrUpdateObject(session)
				}
			}
		}
		
		(self.timetableView.currentView as! DateTableView).setContentOffset(CGPoint(x: 0, y: 0), animated: true)
		
		self.timetableView.scrollEnabled = true
	}

	func realmSetSchema() {
		RLMRealm.setSchemaVersion(7, forRealmAtPath: RLMRealm.defaultRealmPath(), withMigrationBlock: { migration, oldSchemaVersion in
			migration.enumerateObjects(Session.className()) { oldObject, newObject in
				if oldSchemaVersion < 6 {
					self.realm!.transactionWithBlock() {
						self.realm!.addOrUpdateObject(Subject(title: "", location: "", deduction: 0))
					}
				}
			}
			
			migration.enumerateObjects(Subject.className()) { oldObject, newObject in
				if oldSchemaVersion < 7 {
					newObject["title"] = oldObject["title"]
					newObject["location"] = oldObject["location"]
					newObject["deduction"] = oldObject["deduction"]
				}
			}
		})
	}
}
