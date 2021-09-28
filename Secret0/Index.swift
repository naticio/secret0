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
                        destination: NameOnboardingView()
                            .environmentObject(ContentModel())
                            .navigationBarHidden(true),
                        label: {
                            Text("Create an Account")
                        })
                        .padding()
                    
                    ///SIGN IN
                    NavigationLink(
                        destination: LoginView()
                            .environmentObject(ContentModel()),
                        label: {
                            Text("Log In")
                        })
                        .padding()
                    

                    Spacer()
                    
                    
                }
                
            }
            
            .background(WelcomeVideo())
            .edgesIgnoringSafeArea(.all)
        }
//
//        NavigationView {
//            ZStack {
//                //                WelcomeVideo()
//                //                .edgesIgnoringSafeArea(.all)
//                VStack {
//
//                    //logo
//                    Image(systemName: "bolt.heart.fill").resizable().scaledToFit().frame(maxWidth: 50)
//                        .padding(.top, 60)
//                        .foregroundColor(.red)
//
//                    //title
//                    Text("Secret0")
//                        .font(.title)
//                        .bold()
//
//                    Spacer()
//                    Spacer()
//
//                    Text("By signing up for Secret0, you agree to our Terms of Service. Lean how we process your data in our Privacy Policy and Cookies Policy")
//                        .font(.footnote)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                        .padding(.all,20)
//
//                    //if self.signIn == false {
//                    //button create account
//                    //                        Button {
//                    //                            //show login view
//                    //                            isOnboarding = true //to flip loggedin in to true, the launch view will hanlde the logic
//                    //                        } label: {
//                    //                            Text("Create an Account")
//                    //                        }
//                    //                        .padding(.bottom, 20)
//
//                    //SIGN UP
//                    NavigationLink(
//                        destination: NameOnboardingView()
//                            .environmentObject(ContentModel())
//                            .navigationBarHidden(true),
//                        label: {
//                            Text("Create an Account")
//                        })
//                        .padding(.bottom,10)
//
//                    ///SIGN IN
//
//                    NavigationLink(
//                        destination: LoginView()
//                            .environmentObject(ContentModel()),
//                        label: {
//                            Text("LOG IN")
//                        })
//                        .padding(.bottom,10)
//
//                    //SIGN IN
//                    //                        Button(action: {
//                    //                            //show login view
//                    //                            self.showSignInSheet.toggle() //to flip loggedin in to true, the launch view will hanlde the logic
//                    //
//                    //                        }, label: {
//                    //                            Text("Sign In")
//                    //                        })
//                    //
//                    //                        .sheet(isPresented: $showSignInSheet, content: {
//                    //                            LoginSubView(showSheet: $showSignInSheet)
//                    //                        })
//
//
//                    Spacer()
//
//
//                }
//
//            }
//
//            .background(WelcomeVideo())
//            .edgesIgnoringSafeArea(.all)
//
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
        //.navigationViewStyle(StackNavigationViewStyle())
        //.background(Color.white)
        //.navigationBarHidden(true)
    }
}



struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Index()
    }
}
