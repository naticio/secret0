//
//  LoginVierw.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    @EnvironmentObject var model: ContentModel //so we have access to the content model to know if user is loggedin (loggedin property)
    @State var loginMode = Constants.LoginMode.login //we default the value to the constant login..check constant file enum
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    @State var errorMsg: String? //? means nil
    
    
    var body: some View {
        VStack(spacing: 10) {
            
            Spacer()
            
            //logo
            Image(systemName: "bolt.heart.fill").resizable().scaledToFit().frame(maxWidth: 50)
                .padding(.top, 20)
                .foregroundColor(.red)
            
            //title
            Text("Secret0")
                .font(.title)
                .bold()
            
            Spacer()
            
            
            Group { //to avoid having more than 10 elements in the view
                //forms
                TextField("Email", text: $email) //so it looks cute
                SecureField("Password", text: $password)
                
                if errorMsg != nil {
                    Text(errorMsg!)
                }
            }
           
            
            //button
            Button {
               // if loginMode == Constants.LoginMode.login {
                    //log the user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        //check for errors
                        guard error == nil else {
                            errorMsg = error!.localizedDescription
                            return
                        }
                        //clear error mesage for future sign ins
                        self.errorMsg = nil
                        
                        //todo: fetch the user metadata
                        //model.getUserData()
                        
                        //change the view to login view
                        model.checkLogin() //because this will flip the Model published property "loggedIn" to true
                        
                        
                    }
                /*} else {
                    //create new account if the mode IS NOT LOGIN, meaning is sign up
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        //check for errors
                        guard error == nil else {
                            errorMsg = error!.localizedDescription
                            return
                        }
                        //clear error mesage for future sign ins
                        self.errorMsg = nil
                        
                        //save the first name in firebase
                        let db = Firestore.firestore()
                        let firebaseUser = Auth.auth().currentUser
                        let ref = db.collection("users").document(firebaseUser!.uid)
                        
                        ref.setData(["name" : name], merge: true) //merge = true because it updates or adds a user name, does not OVERWRITTE if the username exists
                        
                        //update the user metadata
                        let user = UserService.shared.user ///????????
                        user.name = name //????
                        
                        
                        //change the view to logged in view
                        model.checkLogin()
                        
                       
                    }
                }*/
            } label: {
                ZStack {
                    Rectangle().foregroundColor(.blue).frame(height: 40).cornerRadius(10)
                    Text("Sign in").foregroundColor(.white)
                }
            }
            Spacer()

        }
        .padding(.horizontal)
        .textFieldStyle(RoundedBorderTextFieldStyle()) //this style applies to text fields but by putting it in the container it applies to all text fields inside automatically
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
