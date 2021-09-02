//
//  BreakIceOnboardingView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI

struct BreakIceOnboardingView: View {
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                let index = model.onboardingIndex
                
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                Spacer()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                Image("party girls dance small")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                
                
                Spacer()
                
                NavigationLink(destination: OnboardingQuestions()
                                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                               , isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //BUTTON NEXT
                Button {
                    isOnboarding = true
                    //onboardingScreen = "Questions"
                        goWhenTrue = true
                        
                        if model.onboardingIndex < Constants.screens.count {
                            model.onboardingIndex += 1
                            
                        }
                    
                    
                } label: {
                    if model.onboardingIndex == Constants.screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                }
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

struct BreakIceOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BreakIceOnboardingView()
    }
}
