//
//  LocationOnboarding.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/29/21.
//

import SwiftUI

struct LocationOnboarding: View {
    
    @EnvironmentObject var model: ContentModel
    @EnvironmentObject var localizationModel: LocationModel //jala las func de localizacion
    
    @State var location: String = ""
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var goWhenTrue : Bool = false
    
    @State private var showSignInSheet = false
    
    var body: some View {
        
        
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    
                    //MAP USER. how to do this???
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                
                
                Spacer()
                
                NavigationLink(destination: genderOnboarding(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //oNBOARIDNG NEXT BUTTON
                Button(action: {
                    //save username (to create user once we have password and email
                    
                    if localizationModel.authorizationState == .notDetermined {
                        // If undetermined, show onboarding
                        goWhenTrue = false
                    }
                    else if localizationModel.authorizationState == .authorizedAlways ||
                                localizationModel.authorizationState == .authorizedWhenInUse {
                        // If approved, show home view
                        goWhenTrue = true
                    }
                    else {
                        // If denied show denied view
                        self.showSignInSheet.toggle()
                    }
                        
                        
                        //update indexes
                        if model.onboardingIndex < Constants.screens.count {
                            model.onboardingIndex += 1
                            
                            if model.onboardingIndex == Constants.screens.count {
                                isOnboarding = false
                                model.onboardingIndex = 0
                                model.checkLogin()
                                
                            }
                        }
                    
                }, label: {
                    if model.onboardingIndex == Constants.screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                    
                })
                .sheet(isPresented: $showSignInSheet, content: {
                    LocationDeniedView()
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

struct LocationOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        LocationOnboarding()
    }
}
