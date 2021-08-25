//
//  ContentModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject{
    
    @Published var loggedIn = false //assume user is not loggfed in,published to notify al views that use this property
        //but still this doesn;t mean the user is logedout...we need to check that as well
    
    let db = Firestore.firestore()
    
    init() {
        
    }
    
    //MARK: - authentication methods
    func checkLogin() { //to check if user is logged in or not every time the app opens
        loggedIn = Auth.auth().currentUser == nil ? false : true //if current user is nil then loggedin = false
        
//        //CHECK IF USERR metadaata has been FETCHED. if the uer was already logged in from a previous session, we need to get their data in a separate call
//        if UserService.shared.user.name == "" { //why not nil? because it's a string the name field in firebase
//            getUserData() //to fetch metadata related to user
//        }
    }
}

