//
//  HeightPreferencesView.swift
//  Pods
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI

struct HeightPreferencesView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var goWhenTrue : Bool = false
    @State var selectedeHeight: String = "5'7 ("
    @State var heightOptions = [
        "4'9 (144 cm)",
        "5'0 (152 cm)",
        "5'1 (155 cm)",
        "5'2 (158 cm)",
        "5'3 (160 cm)",
        "5'4 (163 cm)",
        "5'5 (165 cm)",
        "5'6 (168 cm)",
        "5'7 (170 cm)",
        "5'8 (173 cm)",
        "5'9 (175 cm)",
        "5'10 (178 cm)",
        "5'11 (180 cm)",
        "6'0 (183 cm)",
        "6'1 (185 cm)",
        "6'2 (188 cm)",
        "6'3 (190 cm)",
        "6'4 (193 cm)",
        "6'5 (195 cm)"
    ]
    
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
                

                            Picker("", selection: $selectedeHeight) {
                                ForEach(0..<heightOptions.count) { index in
                                    Text(self.heightOptions[index]).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                
                Spacer()
                
                NavigationLink(destination: BreakIceOnboardingView(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //BUTTON NEXT
                Button {
                    if selectedeHeight.contains("144") {
                        model.heightModel = 144
                    }
                    
                    
                        //model.heightModel = selectedeHeight
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

struct HeightPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        HeightPreferencesView()
    }
}
