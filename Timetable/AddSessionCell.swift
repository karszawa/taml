//
//  AddSessionCell.swift
//  Timetable
//
//  Created by Cubic on 2015/03/19.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

class AddSessionCell : UITableViewCell {
	class func instance() -> AddSessionCell {
		return UINib(nibName: "AddSessionCell", bundle: nil).instantiateWithOwner(self, options: nil).first as AddSessionCell
	}
}
