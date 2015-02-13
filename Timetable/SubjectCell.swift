//
//  SubjectCell.swift
//  Timetable
//
//  Created by Cubic on 2015/02/10.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

let SUB_COLOR1 = UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1.0)
let SUB_COLOR2 = UIColor(red: 153/255, green: 170/255, blue: 181/255, alpha: 1.0)
let SUB_COLOR3 = UIColor(red: 204/255, green: 214/255, blue: 221/255, alpha: 1.0)

class SubjectCell : UITableViewCell {
	internal let subject : Subject?
	var titleLabel : UILabel?, periodLabel : UILabel?, locationLabel : UILabel?, deductionLabel : UILabel?

	init(frame : CGRect, subject : Subject) {
		super.init(frame: frame)
		self.subject = subject
		
		titleLabel = UILabel(frame: CGRect(x: frame.origin.x + 20, y: frame.origin.y + frame.height / 3, width: frame.width, height: frame.height * 2 / 3))
		periodLabel = UILabel(frame: CGRect(x: frame.origin.x + 20, y: frame.origin.y + 10, width: frame.width / 2, height: frame.height / 3))
		locationLabel = UILabel(frame: CGRect(x: frame.origin.x + frame.width / 3, y: frame.origin.y + 10, width: frame.width * 2 / 3, height: frame.height / 3))
		deductionLabel = UILabel(frame: CGRect(x: frame.origin.x + frame.width * 4 / 5, y: frame.origin.y + frame.height / 3, width: frame.width / 5, height: frame.height * 2 / 3))
		
		titleLabel!.font = UIFont.systemFontOfSize(27)
		periodLabel!.font = UIFont.systemFontOfSize(18)
		locationLabel!.font = UIFont.systemFontOfSize(18)
		deductionLabel!.font = UIFont.systemFontOfSize(27)
		
		periodLabel!.textColor = SUB_COLOR1
		locationLabel!.textColor = SUB_COLOR1
		deductionLabel!.textColor = PRIMARY_COLOR
		
		updateText()
		
		self.addSubview(titleLabel!)
		self.addSubview(periodLabel!)
		self.addSubview(locationLabel!)
		self.addSubview(deductionLabel!)
		
		sizeToFit()
		
		self.selectionStyle = .None
	}
	
	func updateText() {
		titleLabel!.text = self.subject?.title
		periodLabel!.text = self.subject?.period
		locationLabel!.text = self.subject?.location
		deductionLabel!.text = (self.subject?.deduction == 0 ? nil : subject?.deduction.description)
	}
	
	override func sizeThatFits(_size: CGSize) -> CGSize {
		return CGSize(width: _size.width, height: 100)
	}
	
	func layoutMargins() -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
		self.backgroundColor = (highlighted ? SUB_COLOR3 : UIColor.whiteColor())
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
