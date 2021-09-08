//
//  ContentModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase

class ContentModel: ObservableObject{
    
    @Published var users = [User]()
    @Published var usersLoaded : Bool = false
    
    @Published var loggedIn = false //assume user is not loggfed in,published to notify al views that use this property
        //but still this doesn;t mean the user is logedout...we need to check that as well
    
    @Published var onboardingIndex = 0
    @Published var isOnboarding = false
    
    
    @Published var usernameSignUp = ""
    @Published var emailSignUp = ""
    @Published var passwordSignUp = ""
    @Published var birthdate: Date = Date()
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
    func checkLogin() {
        //to check if user is logged in or not every time the app opens
        loggedIn = Auth.auth().currentUser != nil ? true : false
        //if current user is nil then loggedin = false
        
        //CHECK IF USERR metadata has been FETCHED. if the user was already logged in from a previous session, we need to get their data in a separate call
        if UserService.shared.user.name == "" { //why not nil? because it's a string the name field in firebase
            getUserData() //to fetch metadata related to user
        }
    }
    
    //retrieve user data for the first time
    func getUserData() {
        
        // Check that there's a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get the meta data for that user
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            
            // Check there's no errors
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data out and set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
//            user.lastModule = data?["lastModule"] as? Int
//            user.lastLesson = data?["lastLesson"] as? Int
//            user.lastQuestion = data?["lastQuestion"] as? Int
        }
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
       
}
    
    func getMatches() {

        // Get the documents from the collection
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if error == nil {
                
                var usuarios = [User]() //empty array of user instances
                
                for doc in snapshot!.documents {
                    
                    var u = User()
                    //q.id = doc["id"] as? String ?? ""
                    u.name = doc["name"] as? String ?? ""
                    u.birthdate = doc["birthdate"] as? Date ?? Date()
                    u.gender = doc["gender"] as? String ?? ""
                    u.height = doc["height"] as? Int ?? 0
                    u.latitude = doc["latitude"] as? Double ?? 0.0
                    u.longitude = doc["longitude"] as? Double ?? 0.0
                    
                    u.Q1day2live = doc["Q1day2live"] as? String ?? ""
                    u.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                    u.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                    u.bucketList = doc["bucketList"] as? String ?? ""
                    u.jokes = doc["jokes"] as? String ?? ""
                    
                    usuarios.append(u)
                }
                
                DispatchQueue.main.async {
                    self.users = usuarios
                    self.usersLoaded = true
                }
            }
        }
    }
    
    
    //MARK: - data methods - save data into firebase etc to track the user usage
    //parameter so we don't save to the db every single fucking time...it would be a waste of process! by default false
    func saveUserData(writeToDatabase: Bool = false) {
        
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser { //if auth.auth.currentuser is not nil then it wll lbe assigned to constant loggedInuser and execute code
            //save data locally
            let user = UserService.shared.user //user =  the current user using the app right now
//            user.birthdate = self.birthdate //save to firebase user the values saved in the content model
//            user.location = self.locationModel
//            user.gender = self.genderModel
//            user.sexuality = self.sexualityModel
//            user.datingPreferences = self.datingPrefModel
//            user.height = self.heightModel
//            user.Q1day2live = self.Q1day2liveModel
//            user.QlotteryWin = self.QlotteryWinModel
//            user.QmoneynotanIssue = self.QmoneynotanIssueModel
//            user.bucketList = self.bucketListModel
//            user.jokes = self.jokesModel

            //save to the database
//            if writeToDatabase { //equal to true
//                let db = Firestore.firestore()
//                let ref = db.collection("users").document(loggedInUser.uid)
//                ref.setData(["birthdate" : user.birthdate,
//                             "location" : user.location,
//                             "gender" : user.gender,
//                             "sexuality" : user.sexuality,
//                             "datingPreferences" : user.datingPreferences,
//                             "height" : user.height,
//                             "Q1day2live" : user.Q1day2live,
//                             "QlotteryWin" : user.QlotteryWin,
//                             "QmoneynotanIssue" : user.QmoneynotanIssue,
//                             "bucketList" : user.bucketList,
//                             "jokes" : user.jokes],
//                            merge: true) //merge into doc, not override
//            }


        }
    }
    

    
}

