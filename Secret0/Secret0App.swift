//
//  Secret0App.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import SwiftUI
import Firebase
import FirebaseAuth


//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    FirebaseApp.configure()
//
//    return true


@main
struct Secret0App: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("isOnboarding") var isOnboarding = true

   
    //PREVIOUS FIREBASE INITIALIZATOION
    init(){
        FirebaseApp.configure()
    }
    //change
    
    var body: some Scene {
        WindowGroup {
           LaunchLogicView()
            .environmentObject(ContentModel())
            .environmentObject(LocationModel())
        //declare environment object to cascade my viewModel throughout the app sub views
        }
    }
}
