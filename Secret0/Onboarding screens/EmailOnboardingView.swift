//
//  EmailOnboardingView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI

struct EmailOnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //var screen: onboardingScreen
    
    @State var email: String = ""
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                let index = model.onboardingIndex
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                    
                    TextField("email", text: $email).font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                Spacer()
                
            
                
                //oNBOARIDNG NEXT BUTTON
                Button(action: {
                    //save username (to create user once we have password and email
                    
                    model.emailSignUp = email
                    
                    //update indexes
                    if model.onboardingIndex < Constants.screens.count {
                        model.onboardingIndex += 1
                        
                        if model.onboardingIndex == Constants.screens.count {
                            isOnboarding = false
                            model.onboardingIndex = 0
                            model.checkLogin()
                            
                        }
                        
                        PwdOnboardingView()
                    }
                }, label: {
                    if model.onboardingIndex == Constants.screens.count {
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
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
}
}

struct EmailOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EmailOnboardingView()
    }
}
