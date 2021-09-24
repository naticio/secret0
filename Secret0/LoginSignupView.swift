//
//  Landing.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginSignupView: View {
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding = false
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMsg: String? //? means nil
    
    @State private var showSignInSheet = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
//                WelcomeVideo()
//                .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    //logo
                    Image(systemName: "bolt.heart.fill").resizable().scaledToFit().frame(maxWidth: 50)
                        .padding(.top, 60)
                        .foregroundColor(.red)
                    
                    //title
                    Text("Secret0")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    Spacer()
                    
                    Text("By signing up for Secret0, you agree to our Terms of Service. Lean how we process your data in our Privacy Policy and Cookies Policy")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.all,20)
                    
                    //if self.signIn == false {
                        //button create account
//                        Button {
//                            //show login view
//                            isOnboarding = true //to flip loggedin in to true, the launch view will hanlde the logic
//                        } label: {
//                            Text("Create an Account")
//                        }
//                        .padding(.bottom, 20)
                        
                        //SIGN UP
                        NavigationLink(
                            destination: NameOnboardingView()
                                .environmentObject(ContentModel())
                                .navigationBarHidden(true),
                            label: {
                                Text("Create an Account")
                            })
                            .padding(.bottom,10)
                
                        
                        //SIGN IN
                        Button(action: {
                            //show login view
                            self.showSignInSheet.toggle() //to flip loggedin in to true, the launch view will hanlde the logic
                            
                        }, label: {
                            Text("Sign In")
                        })

                        .sheet(isPresented: $showSignInSheet, content: {
                            LoginSubView(showSheet: $showSignInSheet)
                        })
                        
                        Spacer()
                       
                    
                   // }
                    
                }
                
                
                
            }
        
            .background(WelcomeVideo())
            .edgesIgnoringSafeArea(.all)
        
        }
        .background(Color.white)
        .navigationBarHidden(true)
        
      
        
        
        
        
    }
}

//MARK: - loginsubview sheet
struct LoginSubView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMsg: String? //? means nil
    
    @Binding var showSheet: Bool
    
    var body: some View {
        self.background(Color.white)
        
        Spacer()
        TextField("Email", text: $email) //so it looks cute
        SecureField("Password", text: $password)
        
        self.background(Color.white)
        
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
                self.showSheet.toggle()
                print(self.showSheet)
            } } label: {
                ZStack {
                    Rectangle().foregroundColor(.blue).frame(height: 40).cornerRadius(10)
                    Text("Sign In").foregroundColor(.white)
                }
            }
        Spacer()
    }
}

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}
