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
        
        if model.loggedIn  == false && isOnboarding == false {
            LoginSignUpView()
                .onAppear {
                    //check if user is logged out
                    model.checkLogin()
                }
        } else {
            if model.loggedIn == true && isOnboarding == false {
                HomeView()
                    .onAppear() { model.checkLogin()}
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                BirthOnboardingView(index: 2)
                    .onAppear() {
                        //model.onboardingIndex = 2
                        model.checkLogin()
                    }
                    //save data when app is closed by user
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in //willresign is whne you hidde the app or is out of focus
                        //save data is true
                        model.saveData(writeToDatabase: true)
                    }
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchLogicView()
    }
}
