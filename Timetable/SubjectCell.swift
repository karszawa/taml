//
//  TableViewCell.swift
//  Timetable
//
//  Created by Cubic on 2015/02/13.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import UIKit

class SubjectCell: UITableViewCell {
	@IBOutlet weak var periodLabelView: UILabel!
	@IBOutlet weak var locationLabelView: UILabel!
	@IBOutlet weak var titleLabelView: UILabel!
	@IBOutlet weak var deductionLabelView: UILabel!

	var subject : Subject? {
		didSet {
			self.periodLabelView.text = self.subject?.period
			self.locationLabelView.text = self.subject?.location
			self.titleLabelView.text = self.subject?.title
			self.deductionLabelView.text = self.subject?.deduction.description
		}
	}
	
	class func instance(subject : Subject) -> SubjectCell {
		var inst = UINib(nibName: "SubjectCell", bundle: nil).instantiateWithOwner(self, options: nil).first as SubjectCell
		inst.subject = subject
		return inst
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
		self.backgroundColor = (highlighted ? SUB_COLOR3 : UIColor.whiteColor())
	}

	func layoutMargins() -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
}
