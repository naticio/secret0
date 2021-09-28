//
//  LoginView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/27/21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {

    @EnvironmentObject var model: ContentModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMsg: String? //? means nil
    
    //@Binding var showSheet: Bool
    
    var body: some View {
        
        Spacer()
        TextField("Email", text: $email) //so it looks cute
            .padding()
        SecureField("Password", text: $password)
            .padding()
        
        //self.background(Color.white)
        
        if errorMsg != nil {
            Text(errorMsg!)
        }
        
        Button {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                //check for errors
                guard error == nil else {
                    errorMsg = error!.localizedDescription
                    return
                }
                //clear error mesage for future sign ins
                self.errorMsg = nil
                
                model.getUserData()
                
                //change the view to login view
                
                model.checkLogin() //because this will flip the Model published property "loggedIn" to true
                //log the user in
                //self.showSheet.toggle()
                //print(self.showSheet)
            }
        } label: {
            ZStack {
                Rectangle().foregroundColor(.blue).frame(height: 40).cornerRadius(10)
                Text("Sign In").foregroundColor(.white)
            }
        }
        Spacer()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewRouter: viewRouter1)
//    }
//}
