//
//  LaunchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI

struct LaunchLogicView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    
    @EnvironmentObject var model: ContentModel //because we depend on content model to know if user is loggedin (loggedin property)
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        
        if model.loggedIn  == false {
            WelcomeView()
                .onAppear {
                    //check if user is logged out
                    model.checkLogin()
                }
        } else {
            if isOnboarding == true {
                
                BirthOnboardingView()
                    .onAppear() {
                        model.onboardingIndex = 2
                        model.checkLogin()
                        
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {

                HomeView()
                    .onAppear() { model.checkLogin()}
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchLogicView()
    }
}
