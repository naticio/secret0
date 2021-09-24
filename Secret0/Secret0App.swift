//
//  Secret0App.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import SwiftUI
import Firebase

//DO I NEED TO DO THIS IOR THE INIT BELOW IS SUFFICIENT?
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct Secret0App: App {
    @AppStorage("isOnboarding") var isOnboarding = true
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
   
    //PREVIOUS FIREBASE INITIALIZATOION
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           LaunchLogicView()
            .environmentObject(ContentModel())
            .environmentObject(LocationModel())
        //declare environment object to cascade my viewModel throughout the app sub views
        }
    }
}
