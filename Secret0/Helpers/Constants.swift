//
//  Constants.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation
import Firebase

struct Constants {
    
    enum LoginMode { //an extension to the loginMode propperty defined in LoginView...so you can do LoginMode.login....it's like an optional
        case login
        case createAccount
    }
    
    static var screens = [
        onboardingScreen(title: "Type your email & choose a password", disclaimer: "This email will be used for password recovery", image: "envelope.circle"), //for image use system name string
        onboardingScreen(title: "How do you want to be called?", disclaimer: "You can use a fiction name if you want to", image: "person.circle.fill"), //for image use system name string
        onboardingScreen(title: "When is your birthdate?", disclaimer: "This can't be changed later", image: "calendar.circle"),
        onboardingScreen(title: "Never miss a message from someone great", disclaimer: "", image: "moon.zzz.fill"),
        onboardingScreen(title: "Where do you live?", disclaimer: "Only neighborhood name is shown", image: "location"),
        onboardingScreen(title: "What's your gender?", disclaimer: "", image: "person.circle.fill"),
        onboardingScreen(title: "What's your sexuality?", disclaimer: "", image: "sparkles"),
        onboardingScreen(title: "Who do you want to date?", disclaimer: "", image: "heart.circle.fill"),
        onboardingScreen(title: "How tall are you?", disclaimer: "", image: "ruler"),
        onboardingScreen(title: "Help others break the ice", disclaimer: "", image: "bolt.circle.fill"),
        onboardingScreen(title: "If you had one day left to live, what would you do?", disclaimer: "", image: "1.square.fill"),
        onboardingScreen(title: "What would you do if you won $100,000,000?", disclaimer: "", image: "dollarsign.circle.fill"),
        onboardingScreen(title: "If money didn't matter, what would you do with your time?", disclaimer: "", image: "clock.fill"),
        onboardingScreen(title: "What are three things on your bucket list?", disclaimer: "", image: "list.bullet.circle.fill"),
        onboardingScreen(title: "Know Any Good Jokes?", disclaimer: "", image: "mouth.fill"),
        
    ]
    
    static var pixlabAPIkey = "538f491a89c9026c28be8583aaf7219c"
    //static var apiUrl = "https://api.yelp.com/v3/businesses/search"
    
    static var faceBlurAPIkey = "7703bb8c2bf1461ebd5547a32b12db34"
    

//
//    let databaseRoot = Database.database().reference()
//    let databaseChats = databaseRoot.child("chats")

}
