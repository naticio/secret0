//
//  NotifOnboarding.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/29/21.
//

import SwiftUI

struct NotifOnboarding: View {
    @EnvironmentObject var model: ContentModel
    @EnvironmentObject var locModel: LocationModel
    @State var index : Int
    
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    
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
                
                Spacer()
                
                NavigationLink(
                    destination: LocationOnboarding(index: index+1)
                        .environmentObject(LocationModel())
                        .environmentObject(ContentModel())
                        .onAppear {
                            locModel.requestGeolocationPermission()
                        }
                    , isActive: $goWhenTrue) {
                    //ONBOARIDNG NEXT BUTTON
                    Button(action: {
                        //save into model
                        
                        isOnboarding = true
                        //onboardingScreen = "Location"
                        goWhenTrue = true
                        
                        //update indexes
                        //update indexes
                        //                        if model.onboardingIndex < Constants.screens.count {
                        //                            model.onboardingIndex += 1
                        //
                        //                        }
                        
                    }, label: {
                        Text("Next")
                        
                    })
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

struct NotifOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        NotifOnboarding(index: 2)
    }
}
