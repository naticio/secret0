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
    
    @Published var onboardingIndex = 0
    
    @Published var usernameSignUp = ""
    @Published var emailSignUp = ""
    @Published var passwordSignUp = ""
    @Published var age: Int = 0
    @Published var locationModel: String = ""
    @Published var genderModel: String = ""
    @Published var sexualityModel: String = ""
    @Published var datingPrefModel: String = ""
    @Published var heightModel: Int = 0
    @Published var Q1day2liveModel: String = ""
    @Published var QlotteryWinModel: String = ""
    @Published var QmoneynotanIssueModel: String = ""
    @Published var bucketListModel: String = ""
    @Published var jokesModel: String = ""
    
    
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
    
    func signInUser(email:String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            //check for errors
            guard error == nil else {
                let errorMsg = error!.localizedDescription
                return
            }
            //clear error mesage for future sign ins
            //errorMsg = nil
            
            //todo: fetch the user metadata
            //model.getUserData()
            
            //change the view to login view
            
            self.checkLogin() //because this will flip the Model published property "loggedIn" to true
    }
        
        //MARK: - data methods
        //save data into firebase etc to track the user usage
        func saveData(writeToDatabase: Bool = false) { //parameter so we don't save to the db every single fucking time...it would be a waste of process! by default false
            
            //make sure user is not nil
//            if let loggedInUser = Auth.auth().currentUser { //if auth.auth.currentuser is not nil then it wll lbe assigned to constant loggedInuser and execute code
//                //save data locally
//                let user = UserService.shared.user //user =  the current user using the app right now
//                user.age = currentModuleIndex
//                user.lastLesson = currentLessonIndex
//                user.lastQuestion = currentQuestionIndex
//
//                //save to the database
//                if writeToDatabase { //equal to true
//                    let db = Firestore.firestore()
//                    let ref = db.collection("users").document(loggedInUser.uid)
//                    ref.setData(["lastModule" : user.lastModule,
//                                 "lastLesson" : user.lastLesson,
//                                 "lastQuestion" : user.lastQuestion],
//                                merge: true) //merge into doc, not override
//                }
//
//
//            }
        }
    
}
}

