//
//  AppData.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/7/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import Foundation

class AppData: NSObject {
    
    var userInfomation = StudentInformation(studentInfomation: [String:AnyObject]())
    var studentInformationList = [StudentInformation]()
    
    class func sharedInstance() -> AppData {
        struct Singleton {
            static var sharedInstance = AppData()
        }
        return Singleton.sharedInstance
    }
}