//
//  HomeView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/2/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        Text("Home View perrillas")
        
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
