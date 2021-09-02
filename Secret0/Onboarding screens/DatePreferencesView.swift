//
//  DatePreferencesView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI

struct DatePreferencesView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    //var screen: onboardingScreen
    
    @State var goWhenTrue : Bool = false
    @State var menPressed : Bool = false
    @State var womenPressed : Bool = false
    @State var everyOnePressed : Bool = false
    
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
                
                HStack {
                    //Male button
                    Button {
                        self.menPressed = true
                        self.womenPressed = false
                        self.everyOnePressed = false
                        
                    } label: {
                        Text("Men")
                    }
                    .padding()
                    .background(menPressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                    
                    //Female button
                    Button {
                        self.womenPressed = true
                        self.menPressed = false
                        self.everyOnePressed = false
                        
                    } label: {
                        Text("Women")
                    }
                    .padding()
                    .background(womenPressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                    
                    //everyone button
                    Button {
                        self.everyOnePressed = true
                        self.womenPressed = false
                        self.menPressed = false
                        
                    } label: {
                        Text("Everyone")
                    }
                    .padding()
                    .background(everyOnePressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                }
                
                
                Spacer()
                
                NavigationLink(destination: HeightPreferencesView(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //BUTTON NEXT
                Button {
                    if menPressed == true || womenPressed == true || everyOnePressed == true {
                        if menPressed == true { model.datingPrefModel = "Men" }
                        if womenPressed == true { model.datingPrefModel = "Women" }
                        if everyOnePressed == true { model.datingPrefModel = "Everyone" }
                           
                            isOnboarding = true
                        //onboardingScreen = "Height"
                            goWhenTrue = true
                            
                            //update indexes
                            if model.onboardingIndex < Constants.screens.count {
                                model.onboardingIndex += 1
                                
                            }
                    }
                    
                } label: {
                    if model.onboardingIndex == Constants.screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                }
                .disabled(menPressed == false && womenPressed == false && everyOnePressed == false)
                .padding()
                .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                .frame(width: 100)
            
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DatePreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        DatePreferencesView()
    }
}
