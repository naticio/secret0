//
//  OnboardingContainerView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

//CONTAINS THE OTHER ONBOARDING VIEW
import SwiftUI

struct OnboardingContainerView: View {
    var body: some View {
        TabView { //for the sliding thing
            ForEach(screens) { pantalla in
                OnboardingContentView(screen: pantalla)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
