//
//  UserService.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/9/21.

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
