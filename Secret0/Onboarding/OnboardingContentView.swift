//
//  OnboardingContentView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI

//he declares them in the subview but reflected in thge upper main when called?

let screens = [
    onboardingScreen(title: "How do you want to be called?", disclaimer: "You can use a fiction name if you want to", image: "person"), //for image use system name string
    onboardingScreen(title: "What's your date of birth?", disclaimer: "This can't be changed later", image: "rosette"),
    onboardingScreen(title: "Never miss a message from someone great", disclaimer: "", image: "zzz"),
    onboardingScreen(title: "Adding basic info leads to better matches", disclaimer: "Only neighborhood name is shown", image: "location"),
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

struct OnboardingContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var screen: onboardingScreen
    
    
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                Image(systemName: screen.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                
                VStack(spacing: 20) {
                    Text(screen.title)
                        .font(.system(size: 24, weight: .bold))
                    Text(screen.disclaimer)
                        .font(.caption)
                }
                .padding()
                
                Spacer()
                
            
                
                //oNBOARIDNG NEXT BUTTON
                Button(action: {
                    if model.onboardingIndex < screens.count {
                        model.onboardingIndex += 1
                        
                        if model.onboardingIndex == screens.count {
                            isOnboarding = false
                            model.onboardingIndex = 0
                            model.checkLogin()
                            
                        }
                    }
                }, label: {
                    if model.onboardingIndex == screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                    
                })
                .padding()
                .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                .frame(width: 100)
                
//                Button(action: { isOnboarding = false }, label: {
//                    Text("Next")
//                        .padding()
//                        .background(
//                            Capsule().strokeBorder(Color.white, lineWidth: 1.5)
//                                .frame(width: 100)
//                        )
//                })
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContentView(screen: screens[0])
    }
}
