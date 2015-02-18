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

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()

		self.delegate = self
		self.dataSource = self
	}
	
	class func instance(date : NSDate, sessions : [Session?]) -> DateTableView {
		return UINib(nibName: "DateTableView", bundle: nil).instantiateWithOwner(self, options: nil).first as DateTableView => {
			$0.date = date
			$0.sessions = sessions
			$0.reloadData()
			$0.tableFooterView = UIView()
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sessions.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let session = sessions[indexPath.row] {
			return SubjectCell.instance(session)
		} else {
			return tableView.cellForRowAtIndexPath(indexPath) ?? UITableViewCell()
		}
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section : NSInteger) -> UIView {
		var label = UILabel(frame: CGRect(x: 0, y: 8, width: self.frame.size.width, height: self.sectionHeaderHeight - 8)) => {
			$0.font = .systemFontOfSize(27)
			$0.textAlignment = .Center
			$0.backgroundColor = UIColor.PrimaryColor
			$0.textColor = UIColor.SubColor4
		}
		
		if self.date == TODAY {
			label.text = "今日"
		} else if self.date == TODAY.succ(.DayCalendarUnit, value: 1) {
			label.text = "明日"
		} else {
			label.text = "\(self.date!.month())月\(self.date!.day())日 " + NSCalendar.weekdays[self.date!.weekday()]
		}
		
		return UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.sectionHeaderHeight)) => {
			$0.backgroundColor = UIColor.PrimaryColor
			$0.addSubview(label)
		}
	}
}
