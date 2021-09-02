//
//  HomeView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @AppStorage("onboardingScreen") var onboardingScreen: String?
    
    var body: some View {
        ZStack {
            Color.red
            
            VStack {
                Text("HOME VIEW")
                
                Button {
                    //sign out the user
                    try! Auth.auth().signOut() //we're using try because we're not interested to catch an error when signin out
                    
                    isOnboarding = false
                    //change to log out view
                    model.checkLogin()
                    
                } label: {
                    Text("Sign Out")
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
