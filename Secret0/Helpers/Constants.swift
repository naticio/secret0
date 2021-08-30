//
//  Constants.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation

struct Constants {
    
    enum LoginMode { //an extension to the loginMode propperty defined in LoginView...so you can do LoginMode.login....it's like an optional
        case login
        case createAccount
    }
    
    static var screens = [
        onboardingScreen(title: "How do you want to be called?", disclaimer: "You can use a fiction name if you want to", image: "person"), //for image use system name string
        onboardingScreen(title: "Type and email & choose a password?", disclaimer: "This email will be used for password recovery", image: "envelope"), //for image use system name string
        onboardingScreen(title: "What's your date of birth?", disclaimer: "This can't be changed later", image: "rosette"),
        onboardingScreen(title: "Never miss a message from someone great", disclaimer: "", image: "zzz"),
        onboardingScreen(title: "Where do you live?", disclaimer: "Only neighborhood name is shown", image: "location"),
        onboardingScreen(title: "What's your gender?", disclaimer: "", image: "person"),
        onboardingScreen(title: "What's your sexuality?", disclaimer: "", image: "sparkles"),
        onboardingScreen(title: "Who do you want to date?", disclaimer: "", image: "heart"),
        onboardingScreen(title: "How tall are you?", disclaimer: "", image: "ruler"),
        onboardingScreen(title: "What's your gender", disclaimer: "", image: "person"),
        onboardingScreen(title: "Help others break the ice", disclaimer: "", image: "flame"),
        onboardingScreen(title: "If you had one day left to live, what would you do?", disclaimer: "", image: "flame"),
        onboardingScreen(title: "What would you do if you won $100,000,000?", disclaimer: "", image: "flame"),
        onboardingScreen(title: "If money didn't matter, what would you do with your time?", disclaimer: "", image: "flame"),
        onboardingScreen(title: "What are three things on your bucket list?", disclaimer: "", image: "flame"),
        onboardingScreen(title: "Know Any Good Jokes?", disclaimer: "", image: "flame"),
        
    ]

}
