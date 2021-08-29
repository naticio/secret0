//
//  OnboardingContainerView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

//CONTAINS THE OTHER ONBOARDING VIEW
import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding = false
    
    //@State var isSearching = false
   
    
    var body: some View {
//        TabView { //for the sliding thing
//            ForEach(screens) { pantalla in
//                OnboardingContentView(screen: pantalla)
//                    .gesture(isSearching ? DragGesture() : nil)
//            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//        .edgesIgnoringSafeArea(.all)
//        .navigationBarHidden(true)
        
        if model.loggedIn && isOnboarding == false {
            HomeView()
        } else {
            
            OnboardingContentView(screen: screens[model.onboardingIndex])
                .navigationBarHidden(true)
        }
        
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
