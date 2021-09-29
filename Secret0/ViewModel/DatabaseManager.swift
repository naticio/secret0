//
//  DatabaseManager.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/27/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

//MARK: - Account Management
extension DatabaseManager {
    //escaping becayuse its async
    public func userExists(with email: String, completion: @escaping ((Bool)->Void)) {
        //observe database
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
            }
            
            //if we found email
            completion(true)
        })
    }
    
    ///inserts new user to db
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "first_name": user.firstName
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let emailAddress: String
    //later I can add images etc
}
