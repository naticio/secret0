//
//  EmailOnboardingView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct EmailOnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    //var screen: onboardingScreen
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var goWhenTrue : Bool = false
    @State var errorMsg: String?
    
    @State var index: Int = 0
    
    var body: some View {
        ZStack {

            VStack {
                Spacer()
                //let index = model.onboardingIndex
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                    
                    TextField("email", text: $email).font(.title)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .bottom, .trailing])
                    SecureField("password", text: $password).font(.title)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .bottom, .trailing])
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                //warning message if the text is not formatted correctly
                if errorMsg != nil {
                    Text(errorMsg!)
                }
                
                NavigationLink(destination: NameOnboardingView(index: index+1)
                                .navigationBarBackButtonHidden(true)
                               , isActive: $goWhenTrue) {
                    Button {
                        //call firebase create user
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            //check for errors
                            guard error == nil else {
                                errorMsg = error!.localizedDescription
                                return //EXIT TODO EL CODIGO ALV
                            }
                            //clear error mesage for future sign ins
                            self.errorMsg = nil
                            
                            //save the first name in firebase
//                            let db = Firestore.firestore()
//                            let firebaseUser = Auth.auth().currentUser
//                            let ref = db.collection("users").document(email)
                            //let name =  model.usernameSignUp
                            
                            //merge = true because it updates or adds a user name, does not OVERWRITTE if the username exists
                            //ref.setData(["name" : name], merge: true)
                            
                            //update the user metadata
                            let user = UserService.shared.user ///????????
                            //user.name = name
                            
                            //create REALTIME DB chat entry for the user
//                            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: name, emailAddress: email))
//
                            //flip the switch to navigation view to go to BIRTHDATE VIEW
                            isOnboarding = true
                            //onboardingScreen = "Birthdate"
                            goWhenTrue = true
                            //save into model the email and password
                            //model.emailSignUp = email
                            //model.passwordSignUp = password
                        
                           
//                              if model.onboardingIndex < Constants.screens.count-1 {
//                                  model.onboardingIndex += 1
//
//                              }
                        }
                        
                    } label: {
                            Text("Next")
                    }
                    .padding()
                    .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                    .frame(width: 100)
                    .accentColor(.red)
                    .font(.title)
                }
    
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    //MARK: - firebase CREATE USER
//    func signUpUser(email: String, password: String, name: String) {
//
//        DispatchQueue.main.async {
//            // Create a new account
//            Auth.auth().createUser(withEmail: email, password: password) { result, error in
//
//                // Check for errors
//                guard error == nil else {
//                    errorMsg = error!.localizedDescription
//                    return
//                }
//
//
//                // Save the first name
//                let db = Firestore.firestore()
//                let firebaseuser = Auth.auth().currentUser
//                let ref = db.collection("users").document(firebaseuser!.uid)
//
//                ref.setData(["name": name], merge: true)
//                //firebase saves emaill and pwd behind the scenes?  no need to save them?
//
//                // Update the user meta data
//                let user = UserService.shared.user
//                user.name = name
//
//                // Change the view to logged in view
//                //model.checkLogin()
//
//            }
//        }
//        }
        
}
//
struct EmailOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EmailOnboardingView(index: 1)
            .environmentObject(ContentModel())
    }
}
