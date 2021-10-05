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
import SwiftUI

class ContentModel: ObservableObject{
    
    
    @Published var matches = [Matches]()
    @Published var usersLoaded : Bool?
    
    @Published var userDataCompletion = false
    @Published var loggedIn = false //assume user is not loggfed in,published to notify al views that use this property
    //but still this doesn;t mean the user is logedout...we need to check that as well
    
    @Published var onboardingIndex = 0
    @Published var isOnboarding = false
    
    //matches images
    @Published var images: [UIImage] = [UIImage()]
    
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
        loggedIn = Auth.auth().currentUser == nil ? false : true
        //if current user is nil then loggedin = false
        
        //CHECK IF USERR metadata has been FETCHED. if the user was already logged in from a previous session, we need to get their data in a separate call
        if UserService.shared.user.name == "" { 
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
        //let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        let ref = db.collection("users").document(Auth.auth().currentUser!.displayName ??  "")
        
        ref.getDocument { snapshot, error in
            
            // Check there's no errors
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data out and set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            
            user.name = data?["name"] as? String ?? ""
            user.birthdate = data?["birthdate"] as? Date ?? Date()
            user.gender = data?["gender"] as? String ?? ""
            user.height = data?["height"] as? Int ?? 0
            user.latitude = data?["latitude"] as? Double ?? 0.0
            user.longitude = data?["longitude"] as? Double ?? 0.0
            user.datingPreferences = data?["datingPreferences"] as? String ?? ""
            user.sexuality = data?["sexuality"] as? String ?? ""
            
            //did I use photo as prefix when saving in firebase?
            user.imageUrl1 = data?["photo1"] as? String ?? ""
            user.imageUrl2 = data?["photo2"] as? String ?? ""
            user.imageUrl3 = data?["photo3"] as? String ?? ""
            user.imageUrl4 = data?["photo4"] as? String ?? ""
            user.imageUrl5 = data?["photo5"] as? String ?? ""
            user.imageUrl6 = data?["photo6"] as? String ?? ""
            
            
            user.Q1day2live = data?["Q1day2live"] as? String ?? ""
            user.QlotteryWin = data?["QlotteryWin"] as? String ?? ""
            user.QmoneynotanIssue = data?["QmoneynotanIssue"] as? String ?? ""
            user.bucketList = data?["bucketList"] as? String ?? ""
            user.jokes = data?["jokes"] as? String ?? ""
            
            self.userDataCompletion = true
        }
    }
    
    func getMatches() {
        
        // Get the documents from the collection
        let usersCollection = db.collection("users")
        
        //if user wants to date FEMALE
        let currentUser = UserService.shared.user
        
        if currentUser.datingPreferences == "Women" {
            let query = usersCollection.whereField("gender", in: ["Women"])
            //let query2 = usersCollection.whereField("datingPreferences", in: [user.gender, "Everyone"])
            
            query.getDocuments { snapshot, error in
                if error == nil {
                    
                    var matches = [Matches]() //empty array of user/matches instances
                    
                    for doc in snapshot!.documents {
                        if doc["datingPreferences"] != nil {
                            if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                var m = Matches()
                                m.id = doc["id"] as? String ?? ""
                                m.name = doc["name"] as? String ?? ""
                                m.birthdate = doc["birthdate"] as? Date ?? Date()
                                m.gender = doc["gender"] as? String ?? ""
                                m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                m.height = doc["height"] as? Int ?? 0
                                m.latitude = doc["latitude"] as? Double ?? 0.0
                                m.longitude = doc["longitude"] as? Double ?? 0.0
                                
                                m.imageUrl1 = doc["photo1"] as? String ?? ""
                                m.imageUrl2 = doc["photo2"] as? String ?? ""
                                m.imageUrl3 = doc["photo3"] as? String ?? ""
                                m.imageUrl4 = doc["photo4"] as? String ?? ""
                                m.imageUrl5 = doc["photo5"] as? String ?? ""
                                m.imageUrl6 = doc["photo6"] as? String ?? ""
                                
                                m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                m.bucketList = doc["bucketList"] as? String ?? ""
                                m.jokes = doc["jokes"] as? String ?? ""
                                
                                matches.append(m)
                            }
                        }

                        
                    }
                    
                    DispatchQueue.main.async {
                        self.matches = matches
                        self.usersLoaded = true
                    }
                }
            }
            
        }
        
        //if user wants to date MALE
        if currentUser.datingPreferences == "Men" {
            let query = usersCollection.whereField("gender", in: ["Men"])
            
            query.getDocuments { snapshot, error in
                if error == nil {
                    
                    var matches = [Matches]() //empty array of user/matches instances
                    
                    for doc in snapshot!.documents {
                        if doc["datingPreferences"] != nil {
                            if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                var m = Matches()
                                //q.id = doc["id"] as? String ?? ""
                                m.name = doc["name"] as? String ?? ""
                                m.birthdate = doc["birthdate"] as? Date ?? Date()
                                m.gender = doc["gender"] as? String ?? ""
                                m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                m.height = doc["height"] as? Int ?? 0
                                m.latitude = doc["latitude"] as? Double ?? 0.0
                                m.longitude = doc["longitude"] as? Double ?? 0.0
                                
                                m.imageUrl1 = doc["photo1"] as? String ?? ""
                                m.imageUrl2 = doc["photo2"] as? String ?? ""
                                m.imageUrl3 = doc["photo3"] as? String ?? ""
                                m.imageUrl4 = doc["photo4"] as? String ?? ""
                                m.imageUrl5 = doc["photo5"] as? String ?? ""
                                m.imageUrl6 = doc["photo6"] as? String ?? ""
                                
                                m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                m.bucketList = doc["bucketList"] as? String ?? ""
                                m.jokes = doc["jokes"] as? String ?? ""
                                
                                matches.append(m)
                            
                        }
                        
}
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.matches = matches
                        self.usersLoaded = true
                    }
                }
            }
            
        }
        
        //if user wants to date EVERYONE
        if currentUser.datingPreferences == "Everyone" {
            let query = usersCollection.whereField("gender", in: ["Men", "Women"])
            //.whereField("datingPreferences", in: [user.datingPreferences, user.gender])
            
            query.getDocuments { snapshot, error in
                if error == nil {
                    
                    var matches = [Matches]() //empty array of user/matches instances
                    
                    for doc in snapshot!.documents {
                        if doc["datingPreferences"] != nil {
                            if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                var m = Matches()
                                //q.id = doc["id"] as? String ?? ""
                                m.name = doc["name"] as? String ?? ""
                                m.birthdate = doc["birthdate"] as? Date ?? Date()
                                m.gender = doc["gender"] as? String ?? ""
                                m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                m.height = doc["height"] as? Int ?? 0
                                m.latitude = doc["latitude"] as? Double ?? 0.0
                                m.longitude = doc["longitude"] as? Double ?? 0.0
                                
                                m.imageUrl1 = doc["photo1"] as? String ?? ""
                                m.imageUrl2 = doc["photo2"] as? String ?? ""
                                m.imageUrl3 = doc["photo3"] as? String ?? ""
                                m.imageUrl4 = doc["photo4"] as? String ?? ""
                                m.imageUrl5 = doc["photo5"] as? String ?? ""
                                m.imageUrl6 = doc["photo6"] as? String ?? ""
                                
                                m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                m.bucketList = doc["bucketList"] as? String ?? ""
                                m.jokes = doc["jokes"] as? String ?? ""
                                
                                matches.append(m)
                                
                                DispatchQueue.main.async {
                                    self.matches = matches
                                    self.usersLoaded = true
                                }
                            }
                        }
                        
 
                    }
                    
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
    
    //get 6 images for match
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.images.append(UIImage(data: data) ?? UIImage())
            }
        }
        task.resume()
    }
    
    
    
}

