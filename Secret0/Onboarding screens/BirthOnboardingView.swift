//
//  BirthOnboardingView.swift
//  Pods
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI

struct BirthOnboardingView: View {
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
   // @AppStorage("onboardingScreen") var onboardingScreen: String?
    //var screen: onboardingScreen
    
    @State var birthDate = Date()
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
                    

                    DatePicker("",selection: $birthDate, displayedComponents: [.date])
                    .datePickerStyle(WheelDatePickerStyle())
                
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: NotifOnboarding(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //oNBOARIDNG NEXT BUTTON
                Button(action: {
                    //save username (to create user once we have password and email
                    
                    if userOver18() {
                        //save birthdate into model
                        model.age = birthDate
                        isOnboarding = true
                        //onboardingScreen = "Notifications"
                        
                        goWhenTrue = true
                        
                        //update indexes
                        if model.onboardingIndex < Constants.screens.count {
                            model.onboardingIndex += 1
                           
                        }
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
    
    func userOver18() -> Bool {
        
        let age = Calendar.current.dateComponents([.year, .month, .day], from: birthDate, to: Date())
        
            
        if age.year! > 17 {
            return true
        } else {
            return false
        }
    }
}

struct BirthOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BirthOnboardingView()
    }
}
