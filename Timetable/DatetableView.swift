//
//  dateTableView.swift
//  Timetable
//
//  Created by Cubic on 2015/02/10.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

class DatetableView : UITableView, UITableViewDelegate, UITableViewDataSource {
	var date : NSDate
	var subjects : [Subject]
	var parentViewController : UIViewController
	var calendar = NSCalendar(identifier: NSGregorianCalendar)!
	let weekdays = [ "", "日", "月", "火", "水", "木", "金", "土" ]
	let months = [ "", "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec." ]

	init(frame : CGRect, date : NSDate, inout subjcets : [Subject], parentViewController : UIViewController) {
		self.date = date
		self.subjects = subjcets
		self.parentViewController = parentViewController
		super.init(frame : frame, style: .Plain)
		self.delegate = self
		self.dataSource = self
		self.bounces = false
		self.scrollEnabled = true
		self.estimatedRowHeight = 100
		self.rowHeight = UITableViewAutomaticDimension
		self.separatorInset = UIEdgeInsetsZero
		self.tableFooterView = UIView()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subjects.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let ret = tableView.cellForRowAtIndexPath(indexPath) {
			return ret
		}
		
		let cellFrame = CGRect(x: 0, y: 0, width: frame.width, height: 100)
		var cell = SubjectCell.instance()
		cell.subject = subjects[indexPath.row]
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
		longPressGesture.minimumPressDuration = 1.0;
		cell.addGestureRecognizer(longPressGesture)

		return cell
	}
	
	let headerHeight : CGFloat = 80
	func tableView(tableView: UITableView, heightForHeaderInSection section : NSInteger) -> CGFloat {
		return headerHeight
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section : NSInteger) -> UIView {
		var header = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: headerHeight + 15))
		header.backgroundColor = PRIMARY_COLOR
		
		var headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: headerHeight))
		headerLabel.backgroundColor = PRIMARY_COLOR
		headerLabel.font = UIFont.systemFontOfSize(28)
		headerLabel.textColor = UIColor.whiteColor()
		var comps = (0, 0, 0, 0)
		calendar.getEra(&comps.0, year: &comps.1, month: &comps.2, day: &comps.3, fromDate: date)
		headerLabel.text = "\(comps.2)月\(comps.3)日 \(weekdays[calendar.component(.WeekdayCalendarUnit, fromDate: date)])曜日"
		headerLabel.sizeToFit()
		headerLabel.center = header.convertPoint(header.center, fromCoordinateSpace: header)
		header.addSubview(headerLabel)

		return header
	}
	
	func longPressed(sender: UILongPressGestureRecognizer) {
		if sender.state != UIGestureRecognizerState.Began { return }

		let p = sender.locationInView(self)
		let index = self.indexPathForRowAtPoint(p)!.row
		
		var alert = UIAlertController(title: subjects[index].title, message: "明日は頑張ろう", preferredStyle: .ActionSheet)
		
		let absenceAction = UIAlertAction(title: "欠席(-1.0)", style: .Default, handler: { (action: UIAlertAction!) in
			self.subjects[index].deduction -= 1.0
			self.reloadData()
		})
		let tardinessAction = UIAlertAction(title: "遅刻(-0.5)", style: .Default, handler: { (action: UIAlertAction!) in
			self.subjects[index].deduction -= 0.5
			self.reloadData()
		})
		let cancellAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: nil)
		
		alert.addAction(absenceAction)
		alert.addAction(tardinessAction)
		alert.addAction(cancellAction)
		
		self.parentViewController.presentViewController(alert, animated: true, completion: nil)
	}
}
