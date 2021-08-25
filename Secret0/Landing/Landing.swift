//
//  Landing.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI

struct Landing: View {
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding = true
    
    @State var signIn = false
    
    var body: some View {
        
        ZStack {
        
            
            WelcomeVideo()
            
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //logo
                Image(systemName: "bolt.heart.fill").resizable().scaledToFit().frame(maxWidth: 50)
                    .padding(.top, 20)
                    .foregroundColor(.red)
                
                //title
                Text("Secret0")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Text("By signing up for Secret0, you agree to our Terms of Service. Lean how we process your data in our Privacy Policy and Cookies Policy")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top,20)
                    .padding(.bottom,20)
                
                if signIn == false {
                    //button create account
                    Button {
                        //show onboarding screens
                        isOnboarding = true //to flip loggedin in to true, the launch view will handle the logic???
                    } label: {
                        Text("Create Account")
                    }
                    
                    //button to sign in
                    Button {
                        //show login view
                        signIn = true //to flip loggedin in to true, the launch view will hanlde the logic
                    } label: {
                        Text("Sign In")
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                } else {
                    LoginSubView()
                }
                
            }
            
            
            
        }
    
        .background(WelcomeVideo())
        
        
        Spacer()
        
        
        
        
    }
}

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Landing()
    }
}
