//
//  dateTableView.swift
//  Timetable
//
//  Created by Cubic on 2015/02/10.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit
import Realm

class DateTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
	var date : NSDate?
	var sessions : [Session?] = []
	var textfieldDelegate : FirstViewController?

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()

		self.delegate = self
		self.dataSource = self
		self.setEditing(true, animated: true)
	}
	
	class func instance(date : NSDate, sessions : [Session?], textfieldDelegate : FirstViewController) -> DateTableView {
		return UINib(nibName: "DateTableView", bundle: nil).instantiateWithOwner(self, options: nil).first as DateTableView => {
			$0.date = date
			$0.sessions = sessions
			$0.textfieldDelegate = textfieldDelegate
			$0.reloadData()
			$0.tableFooterView = UIView()
		}
	}
	
	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		for subview in subviews {
			if subview is UITextField {
				subview.setEditing(editing, animated: animated)
			}
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sessions.count + (editing ? 1 : 0)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row < self.sessions.count {
			return SessionCell.instance(self.sessions[indexPath.row]) => {
				$0.titleTextField.delegate = self.textfieldDelegate
				$0.locationTextField.delegate = self.textfieldDelegate
				$0.deductionTextField.delegate = self.textfieldDelegate
			}
		}
		
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section : NSInteger) -> UIView {
		var label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.sectionHeaderHeight)) => {
			$0.font = .systemFontOfSize(27)
			$0.textAlignment = .Center
			$0.backgroundColor = UIColor.PrimaryColor
			$0.textColor = UIColor.SubColor4
		}
		
		if self.date == TODAY {
			label.text = "今日"
		} else if self.date == TODAY.succ(.DayCalendarUnit, value: 1) {
			label.text = "明日"
		} else if self.date == TODAY.succ(.DayCalendarUnit, value: -1) {
			label.text = "昨日"
		} else {
			label.text = "\(self.date!.month())月\(self.date!.day())日 " + NSCalendar.Weekdays[self.date!.weekday()]
//			label.text = NSCalendar.Weekdays[self.date!.weekday()] + ", " + NSCalendar.Months[self.date!.month()] + " \(self.date!.day())"
		}
		
		return UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.sectionHeaderHeight)) => {
			$0.backgroundColor = UIColor.PrimaryColor
			$0.addSubview(label)
		}
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		return .Delete
	}
	
	func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}
