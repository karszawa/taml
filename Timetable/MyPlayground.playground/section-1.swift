// Playground - noun: a place where people can play

import Cocoa

extension NSObject {
	func set<T>(initializer : (T) -> ()) -> T {
		initializer(self as T)
		return self as T
	}
}


var label = UILabel(frame: CGRect(x: 0, y: 0, width: 9, height: 0)).set() {
	$0.font = .systemFontOfSize(27)
	$0.textAlignment = .Center
	$0.backgroundColor = PRIMARY_COLOR
	$0.textColor = SUB_COLOR4
}
