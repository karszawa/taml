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
	var editable = false
	var textfieldDelegate : FirstViewController?

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()

		self.delegate = self
		self.dataSource = self
	}
	
	class func instance(date : NSDate, sessions : [Session?], editable : Bool, textfieldDelegate : FirstViewController) -> DateTableView {
		return UINib(nibName: "DateTableView", bundle: nil).instantiateWithOwner(self, options: nil).first as DateTableView => {
			$0.date = date
			$0.sessions = sessions
			$0.editable = editable
			$0.textfieldDelegate = textfieldDelegate
			$0.reloadData()
			$0.tableFooterView = UIView()
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sessions.count + (editable ? 1 : 0)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if editable {
			if indexPath.row < self.sessions.count {
				return EditableSessionCell.instance(self.sessions[indexPath.row], textfieldDelegate: textfieldDelegate!)
			} else if indexPath.row == self.sessions.count {
				return AddSessionCell.instance()
			}
		} else {
			if indexPath.row < self.sessions.count {
				return SessionCell.instance(self.sessions[indexPath.row])
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
			label.text = "Today"
		} else if self.date == TODAY.succ(.DayCalendarUnit, value: 1) {
			label.text = "Tomorrow"
		} else if self.date == TODAY.succ(.DayCalendarUnit, value: -1) {
			label.text = "Yesterday"
		} else {
			label.text = "\(self.date!.month())月\(self.date!.day())日 " + NSCalendar.Weekdays[self.date!.weekday()]
//			label.text = NSCalendar.Weekdays[self.date!.weekday()] + ", " + NSCalendar.Months[self.date!.month()] + " \(self.date!.day())"
		}
		
		return UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.sectionHeaderHeight)) => {
			$0.backgroundColor = UIColor.PrimaryColor
			$0.addSubview(label)
		}
	}
}
