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

let JWEEKDAYS = [ "", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日" ]
let MONTHS = [ "", "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec." ]

class DateTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
	var date : NSDate?
	var sessions : RLMResults?

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()

		self.delegate = self
		self.dataSource = self
	}
	
	class func instance(date : NSDate, sessions : RLMResults) -> DateTableView {
		return UINib(nibName: "DateTableView", bundle: nil).instantiateWithOwner(self, options: nil).first as DateTableView => {
			$0.date = date
			$0.sessions = sessions
			$0.reloadData()
			$0.tableFooterView = UIView()
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5 // TODO
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return tableView.cellForRowAtIndexPath(indexPath) ?? {
			if let session = self.sessions!.objectsWhere("period = \(indexPath.row + 1)").firstObject() as? Session {
				return SubjectCell.instance(session) => {
					let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
					longPressGesture.minimumPressDuration = 1.0;
					$0.addGestureRecognizer(longPressGesture)
				}
			}
			
			return UITableViewCell()
		}()
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section : NSInteger) -> UIView {
		return self.tableHeaderView ?? {
			var label = UILabel(frame: CGRect(x: 0, y: 8, width: self.frame.size.width, height: self.sectionHeaderHeight - 8)) => {
				$0.font = .systemFontOfSize(27)
				$0.textAlignment = .Center
				$0.backgroundColor = PRIMARY_COLOR
				$0.textColor = SUB_COLOR4
			}
			
			if self.date == TODAY {
				label.text = "今日"
			} else if self.date == TODAY.succ(.DayCalendarUnit, value: 1) {
				label.text = "明日"
			} else {
				label.text = "\(self.date!.month())月\(self.date!.day())日 " + JWEEKDAYS[self.date!.weekday()]
			}
			
			return UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.sectionHeaderHeight)) => {
				$0.backgroundColor = PRIMARY_COLOR
				$0.addSubview(label)
			}
		}()
	}
	
	// should move to Controller
	func longPressed(sender: UILongPressGestureRecognizer) {
		if sender.state != UIGestureRecognizerState.Began {
			return
		}

		let point = sender.locationInView(self)
		if let index = self.indexPathForRowAtPoint(point)?.row {
		
			
			let session = sessions?.objectsWhere("period = %@", index).firstObject() as Session
			var alert = UIAlertController(title: session.subject.title, message: "明日は頑張ろう", preferredStyle: .ActionSheet)
			
			let absenceAction = UIAlertAction(title: "欠席(-1.0)", style: .Default, handler: { (action: UIAlertAction!) in
				session.subject.deduction -= 1.0
				self.reloadData()
			})
			let tardinessAction = UIAlertAction(title: "遅刻(-0.5)", style: .Default, handler: { (action: UIAlertAction!) in
				session.subject.deduction -= 0.5
				self.reloadData()
			})
			let cancellAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
			
			alert.addAction(absenceAction)
			alert.addAction(tardinessAction)
			alert.addAction(cancellAction)
			
			self.getParentViewController()?.presentViewController(alert, animated: true, completion: nil)
		}
	}
}
