//
//  LaunchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI

struct LaunchView: View {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    
    @EnvironmentObject var model: ContentModel //because we depend on content model to know if user is loggedin (loggedin property)
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        
        if model.loggedIn  == false {
            Landing()
                .onAppear {
                    //check if user is logged out
                    model.checkLogin()
                }
        } else {
            if isOnboarding == false {
                HomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingContainerView() //show onboarding
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
