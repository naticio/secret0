//
//  genderOnboarding.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/30/21.
//

import SwiftUI

struct genderOnboarding: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    @State private var maleButtonPressed:Bool = false
    @State private var femaleButtonPressed:Bool = false
    
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
                
                //male and female buttons
                HStack {
                    //Male button
                    Button {
                        self.maleButtonPressed = true
                        
                        if self.femaleButtonPressed == true {
                            self.femaleButtonPressed = false
                        }
                        
                    } label: {
                        Text("Male")
                    }
                    .padding()
                    .background(maleButtonPressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                    
                    //Female button
                    Button {
                        self.femaleButtonPressed = true
                        
                        if self.maleButtonPressed == true {
                            self.maleButtonPressed = false
                        }
                    } label: {
                        Text("Female")
                    }
                    .padding()
                    .background(femaleButtonPressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                }
                

                
                Spacer()
                
                NavigationLink(destination: SexOnboardingView(index: index + 1), isActive: $goWhenTrue) {
                    //ONBOARIDNG NEXT BUTTON
                    Button(action: {
                        if maleButtonPressed == true || femaleButtonPressed == true {
                            if maleButtonPressed == true {model.genderModel = "Male"}
                            if femaleButtonPressed == true {model.genderModel = "Female"}
                            
                            isOnboarding = true
                            //onboardingScreen = "Sexuality"
                            goWhenTrue = true
                            

                        }
                    }, label: {
                            Text("Next")
                        
                    })
                
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
}

//struct genderOnboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        genderOnboarding()
//    }
//}
