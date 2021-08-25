//
//  UserService.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation

//SINGLETON

class UserService {
    
    var user = User() //a single copy of the user class
    
    static var shared = UserService() //create SINGLE INSTANCE
    
    //if we try to create an instance of this lass we canoonnt create it...
    private init() {
        
    }
}
