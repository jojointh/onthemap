//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Surasak on 9/29/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        static let BaseURL: String = "https://www.udacity.com/"
    }
    
    struct Methods {
        static let UserSession = "api/session"
        static let UserData = "api/users/{user_id}"
    }
}
