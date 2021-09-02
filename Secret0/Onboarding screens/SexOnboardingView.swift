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
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    @State var selectedPref: String = "Straight"
    @State var preferences = ["Straight", "Gay", "Lesbian", "Bisexual"]
    
    @State var index: Int
    
    var body: some View {
        ZStack {
            VStack {
                
                //let index = model.onboardingIndex
                
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
                
                NavigationLink(destination: DatePreferencesView(index: index + 1), isActive: $goWhenTrue) {
                    //BUTTON NEXT
                    Button {
                        //save into model the sexuality
                            model.sexualityModel = selectedPref
                            
                            isOnboarding = true
                            //onboardingScreen = "Dating"
                            goWhenTrue = true
                        
                        
                    } label: {

                            Text("Next")
                    }
                    //.disabled(index == nil)
                    .padding()
                    .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                    .frame(width: 100)
                }
                
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}



//struct SexOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SexOnboardingView()
//    }
//}
