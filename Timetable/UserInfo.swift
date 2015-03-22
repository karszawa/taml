//
//  UserInfo.swift
//  Timetable
//
//  Created by Cubic on 2015/03/22.
//  Copyright (c) 2015年 Cubic. All rights reserved.
//

import Foundation
import Realm

class UserInfo : RLMObject {
	dynamic var key = "key"
	dynamic var classInfo = "5EJ"
	
	override init() {
		super.init()
	}
	
	override init(object: AnyObject?) {
		super.init(object:object)
	}
	
	override init(object value: AnyObject!, schema: RLMSchema!) {
		super.init(object: value, schema: schema)
	}
	
	override init(objectSchema: RLMObjectSchema) {
		super.init(objectSchema: objectSchema)
	}

	override class func primaryKey() -> String {
		return "key"
	}
	
	class func origin() -> UserInfo {
		if UserInfo.allObjects().firstObject() == nil {
			var realm = RLMRealm.defaultRealm()
			realm.transactionWithBlock() {
				realm.addOrUpdateObject(UserInfo())
			}
		}
		
		return UserInfo.allObjects().firstObject() as UserInfo
	}
}
