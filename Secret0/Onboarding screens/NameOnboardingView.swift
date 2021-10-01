//
//  Name.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct NameOnboardingView: View {

    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    //var screen: onboardingScreen
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var goWhenTrue : Bool = false
    @State var warningMsg: String = ""
    
    @State var index: Int

    
    var body: some View {
        
        NavigationView{
            
            ZStack {

                VStack {
                    
                    //let index = 0
                    
//                    Image(systemName: Constants.screens[index].image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50, alignment: .center)
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        
                        Text(Constants.screens[index].title)
                            .font(.title)
                            .bold()
                        
                        TextField("Username", text: $username).font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                            .textCase(.lowercase)
                        
                        Text(Constants.screens[index].disclaimer)
                            .font(.caption)
                    }
                    .padding()
                    
                    //warning message if the text is not formatted correctly
                    Text(warningMsg)
                        .font(.system(size: 9))
                
                    NavigationLink(destination: BirthOnboardingView(index: index + 1), isActive: $goWhenTrue) {
                        //BUTTON NEXT
                        Button {

                            if textFormatOK() {
                                //check if name exists in firebase already
                                checkUsername(username: username.lowercased(), completion: { userExist in
                                    if userExist == true {
                                        warningMsg = "Username already exists"
                                    } else {
                                        
                                        //save user name in model
                                        model.usernameSignUp = username
                                        saveDataHere(username: username)
                                        
                                        goWhenTrue = true
                                    }
                                })
                                
                            } else {
                                //show a warning message for the etxt to be longer than 1 chr
                                if username.count == 0 {
                                    warningMsg = "Username must not be empty"
                                }
                                if username.count > 15 {
                                    warningMsg = "Username is too long, must be less than 15 chrs"
                                }
                            }
                        } label: {
                            Text("Next")
                        }
                        .padding()
                        .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                        .frame(width: 100)
                    }
        
                    Spacer()
                    
                }
            }
        }
        .background(Color.white)
        //.navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    //MARK: - check if the Onboarding input field is ok
    func textFormatOK() -> Bool {
        if username.count >= 1 { //more than 1 chr in the username
            return true
        } else {
            return false
        }
        
    }
    
    
    func checkUsername(username: String, completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        
        // Get your Firebase collection
        let collectionRef = db.collection("users")

        // Get all the documents where the field username is equal to the String you pass, loop over all the documents.

        collectionRef.whereField("name", isEqualTo: username).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }

    
    //save data to firebase
    func saveDataHere(username: String) {
        
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user //user =  the current user using the app right now
            user.name = username //save to firebase user the values saved in the content model
            
            //save to the db
            let db = Firestore.firestore()
            let ref = db.collection("users").document(loggedInUser.uid)
            ref.setData(["birthdate" : user.birthdate], merge: true)
        }
    }
    
}

//    struct Name_Previews: PreviewProvider {
//        static var previews: some View {
//            NameOnboardingView()
//        }
//    }
