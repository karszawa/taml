//
//  Extensions.swift
//  Timetable
//
//  Created by Cubic on 2015/02/14.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import UIKit

infix operator => { associativity left precedence 91 }

func => <T>(object: T, initializer: (T) -> ()) -> T {
	initializer(object)
	return object
}

extension UIView {
	func getParentViewController() -> UIViewController? {
		var responder : UIResponder? = self
		while true {
			responder = responder?.nextResponder()? ?? self
			
			if responder == nil {
				return nil
			} else if responder!.isKindOfClass(UIViewController.self) {
				return responder as? UIViewController
			}
		}
	}
}
