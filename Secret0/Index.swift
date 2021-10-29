//
//  Landing.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Index: View {
    
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding = false
    
    //    @State var email: String = ""
    //    @State var password: String = ""
    //    @State var errorMsg: String? //? means nil
    
    @State private var showSignInSheet = false
    
    var body: some View {
        NavigationView{
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
                    
                    
                     //SIGN UP
                     NavigationLink(
                     destination: EmailOnboardingView()
                     .environmentObject(ContentModel()),
                     label: {
                     Text("Create an Account")
                     })
                     .padding()
                     
                     ///SIGN IN navigation link
//                     NavigationLink(
//                     destination: LoginView()
//                     .environmentObject(ContentModel()),
//                     label: {
//                     Text("Log In")
//                     })
//                     .padding()
//
                    
                    
                    ///SIGN IN modal
                    Button(action: {
                        //show login view
                        showSignInSheet = true //to flip loggedin in to true, the launch view will hanlde the logic
                        
                    }, label: {
                        Text("Sign In")
                    })
                    
                        .sheet(isPresented: $showSignInSheet, content: {
                            LoginView(isPresented: $showSignInSheet)
                        })
                    
                    Spacer()
                    
                    
                }
                
            }
            
            .background(WelcomeVideo())
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct LoginView: View {

    @EnvironmentObject var model: ContentModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMsg: String? //? means nil
    
    @Binding var isPresented: Bool
    
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
            isPresented = false
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                //check for errors
                if error == nil {
                    isPresented = false //hide modal
                    
                    self.errorMsg = nil
                    
                    model.checkLogin()
                } else {
                    isPresented = true
                    errorMsg = error!.localizedDescription
                    print("error, valiendo verga: \(errorMsg)")
                    return
                }
                

                //clear error mesage for future sign ins
                
                
                //model.getUserData()
                
                //change the view to login view
                
                //because this will flip the Model published property "loggedIn" to true
                //log the user in

                
                //print(self.showSheet)
            }
        } label: {
            ZStack {
                Rectangle().foregroundColor(.blue).frame(height: 40).cornerRadius(10)
                Text("Sign In").foregroundColor(.white)
            }
        }
        
        Button {
            //restore pwd
        } label: {
            Text("Restore password")
        }

        Spacer()
    }
}


struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Index()
    }
}
