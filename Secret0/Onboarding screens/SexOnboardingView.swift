//
//  SexOnboardingView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/30/21.
//

import SwiftUI

struct SexOnboardingView: View {
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var goWhenTrue : Bool = false
    @State var selectedPref: String = "Straight"
    @State var preferences = ["Straight", "Gay", "Lesbian", "Bisexual"]
    
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
                

                            Picker("", selection: $selectedPref) {
                                ForEach(0..<preferences.count) { index in
                                    Text(self.preferences[index]).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                
                Spacer()
                
                NavigationLink(destination: DatePreferencesView(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //BUTTON NEXT
                Button {
                        model.sexualityModel = selectedPref
                        goWhenTrue = true
                        
                        if model.onboardingIndex < Constants.screens.count {
                            model.onboardingIndex += 1
                            
                            if model.onboardingIndex == Constants.screens.count {
                                isOnboarding = false
                                model.onboardingIndex = 0
                                model.checkLogin()
                                
                            }
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



struct SexOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SexOnboardingView()
    }
}
