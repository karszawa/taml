//
//  TableViewCell.swift
//  Timetable
//
//  Created by Cubic on 2015/02/13.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
	@IBOutlet weak var periodLabelView: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var deductionTextField: UITextField!

	var session : Session? {
		didSet {
			self.periodLabelView.text = self.session.map { $0.period.description + "限" }
			self.titleTextField.text = self.session?.subject.title
			self.locationTextField.text = self.session?.subject.location
			if let d = self.session?.subject.deduction {
				self.deductionTextField.text = (d == 0 ? "" : d.description)
			} else {
				self.deductionTextField.text = ""
			}
		}
	}
	
	class func instance(session : Session?) -> SessionCell {
		return UINib(nibName: "SessionCell", bundle: nil).instantiateWithOwner(self, options: nil).first as SessionCell => {
			$0.session = session
		}
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
		self.backgroundColor = (highlighted ? UIColor.SubColor3 : UIColor.whiteColor())
	}

	func layoutMargins() -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
}
