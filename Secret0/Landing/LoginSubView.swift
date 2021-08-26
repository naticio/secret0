//
//  LoginSubView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginSubView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMsg: String? //? means nil
    
    var body: some View {
        Spacer()
        TextField("Email", text: $email) //so it looks cute
        SecureField("Password", text: $password)
        
        if errorMsg != nil {
            Text(errorMsg!)
        }
        
        Button {
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
            } } label: {
                ZStack {
                    Rectangle().foregroundColor(.blue).frame(height: 40).cornerRadius(10)
                    Text("Sign In").foregroundColor(.white)
                }
            }
        Spacer()
    }
}

struct LoginSubView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSubView()
    }
}
