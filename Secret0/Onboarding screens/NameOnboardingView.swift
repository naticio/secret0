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
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                let index = model.onboardingIndex
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                    
                    TextField("username", text: $username).font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                Spacer()
                
            
                
                //oNBOARIDNG NEXT BUTTON
                
                Button(action: {
                    //save username (to create user once we have password and email
                    
                    model.usernameSignUp = username
                    
                    //update indexes
                    if model.onboardingIndex < Constants.screens.count {
                        model.onboardingIndex += 1
                        
                        if model.onboardingIndex == Constants.screens.count {
                            isOnboarding = false
                            model.onboardingIndex = 0
                            model.checkLogin()
                            
                        }
                        
                        EmailOnboardingView()
                    }
                }, label: {
                    if model.onboardingIndex == Constants.screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                    
                })
                .padding()
                .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                .frame(width: 100)
                
//                Button(action: { isOnboarding = false }, label: {
//                    Text("Next")
//                        .padding()
//                        .background(
//                            Capsule().strokeBorder(Color.white, lineWidth: 1.5)
//                                .frame(width: 100)
//                        )
//                })
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
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
