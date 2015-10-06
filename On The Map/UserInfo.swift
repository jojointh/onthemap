//
//  UserInfo.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/7/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import Foundation

class UserInfo: NSObject {
    
    var userInfomation = StudentInformation(studentInfomation: [String:AnyObject]())
    
    class func sharedInstance() -> UserInfo {
        struct Singleton {
            static var sharedInstance = UserInfo()
        }
        return Singleton.sharedInstance
    }
}