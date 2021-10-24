//
//  ProfileView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        VStack {
            Button {
                //sign out the user
                try! Auth.auth().signOut() //we're using try because we're not interested to catch an error when signin out
                
                isOnboarding = false
                model.usersLoaded =  false
                //UserService.shared.user.name = ""
                model.checkLogin()
                //change to log out view
                //model.loggedIn = false
                
            } label: {
                Text("Sign Out")
            }
    
            
            Text("User logged in: \(UserService.shared.user.name)")
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
