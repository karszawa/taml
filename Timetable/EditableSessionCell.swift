//
//  EditableSessionCell.swift
//  Timetable
//
//  Created by Cubic on 2015/03/19.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

let ord = ["st", "nd", "rd", "th"]

class EditableSessionCell : UITableViewCell {
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var deductionTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var periodLabelView: UILabel!
	
	var session : Session? {
		didSet {
			self.periodLabelView.text = self.session.map { $0.period.description + "限" } //ord[min($0.period-1, 3)] + " period" }
			self.locationTextField.text = self.session?.subject.location
			self.titleTextField.text = self.session?.subject.title
			if let d = self.session?.subject.deduction {
				self.deductionTextField.text = d.description
			} else {
				self.deductionTextField.text = ""
			}
		}
	}
	
	class func instance(session : Session?, textfieldDelegate : FirstViewController) -> EditableSessionCell {
		return UINib(nibName: "EditableSessionCell", bundle: nil).instantiateWithOwner(self, options: nil).first as EditableSessionCell => {
			$0.session = session
			$0.titleTextField.delegate = textfieldDelegate
			$0.deductionTextField.delegate = textfieldDelegate
			$0.locationTextField.delegate = textfieldDelegate
		}
	}
	
	func layoutMargins() -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}	
}