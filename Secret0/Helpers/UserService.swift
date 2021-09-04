//
//  UserService.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/27/21.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
