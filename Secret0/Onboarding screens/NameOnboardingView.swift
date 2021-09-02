//
//  Name.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI
//import FirebaseAuth
//import Firebase

struct NameOnboardingView: View {
    
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    //var screen: onboardingScreen
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var goWhenTrue : Bool = false
    @State var warningMsg: String = ""
    
    var body: some View {
        NavigationView{
            ZStack {
       
                VStack {
                    
                    let index = model.onboardingIndex
                    
                    Image(systemName: Constants.screens[index].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .center)
                    
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        Text(Constants.screens[index].title)
                            .font(.title)
                            .bold()
                        
                        TextField("Username", text: $username).font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text(Constants.screens[index].disclaimer)
                            .font(.caption)
                    }
                    .padding()
                    
                    //warning message if the text is not formatted correctly
                    Text(warningMsg)
                    
                    NavigationLink(destination: EmailOnboardingView(), isActive: $goWhenTrue) {
                        EmptyView()
                    }
                    
                    //BUTTON NEXT
                    Button {
                        if textFormatOK() {
                            //save user name in model
                            model.usernameSignUp = username
                           
                            goWhenTrue = true
                              
                              if model.onboardingIndex < Constants.screens.count {
                                  model.onboardingIndex += 1
                              }
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
                        if model.onboardingIndex == Constants.screens.count {
                            Text("Done")
                        } else {
                            Text("Next")
                        }
                    }
                    .padding()
                    .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                    .frame(width: 100)

                    Spacer()

                    }
                }
            }
            
            .navigationBarHidden(true)
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
        
        //    func signUpUser(email: String, password: String, name: String) {
        //        // Create a new account
        //        Auth.auth().createUser(withEmail: email, password: password) { result, error in
        //
        //            // Check for errors
        //            guard error == nil else {
        //                let errorMessage = error!.localizedDescription
        //                return
        //            }
        //            // Clear error message
        ////                errorMessage = nil
        //
        //            // Save the first name
        //            let firebaseuser = Auth.auth().currentUser
        //            let db = Firestore.firestore()
        //            let ref = db.collection("users").document(firebaseuser!.uid)
        //
        //            ref.setData(["name": name], merge: true)
        //
        //            // Update the user meta data
        //            let user = UserService.shared.user
        //            user.name = name
        //
        //            // Change the view to logged in view
        //            model.checkLogin()
        //        }
        //    }
    }
    
    struct Name_Previews: PreviewProvider {
        static var previews: some View {
            NameOnboardingView()
        }
    }
