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
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    //@State private var index: Int = 0
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
                
                
                Picker("", selection: $selectedeHeight) {
                    ForEach(0..<heightOptions.count) { index in
                        Text(self.heightOptions[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
                
                NavigationLink(destination: BreakIceOnboardingView(index: index + 1).environmentObject(ContentModel()), isActive: $goWhenTrue) {
                    //BUTTON NEXT
                    Button {
                        if selectedeHeight.contains("144") { model.heightModel = 144}
                        if selectedeHeight.contains("152") { model.heightModel = 152}
                        if selectedeHeight.contains("155") { model.heightModel = 155}
                        if selectedeHeight.contains("158") { model.heightModel = 158}
                        if selectedeHeight.contains("160") { model.heightModel = 160}
                        if selectedeHeight.contains("163") { model.heightModel = 163}
                        if selectedeHeight.contains("165") { model.heightModel = 165}
                        if selectedeHeight.contains("168") { model.heightModel = 168}
                        if selectedeHeight.contains("170") { model.heightModel = 170}
                        if selectedeHeight.contains("173") { model.heightModel = 173}
                        if selectedeHeight.contains("175") { model.heightModel = 175}
                        if selectedeHeight.contains("178") { model.heightModel = 178}
                        if selectedeHeight.contains("180") { model.heightModel = 180}
                        if selectedeHeight.contains("183") { model.heightModel = 183}
                        if selectedeHeight.contains("185") { model.heightModel = 185}
                        if selectedeHeight.contains("188") { model.heightModel = 188}
                        if selectedeHeight.contains("190") { model.heightModel = 190}
                        if selectedeHeight.contains("193") { model.heightModel = 193}
                        if selectedeHeight.contains("195") { model.heightModel = 195}
                        
                        isOnboarding = true
                        //onboardingScreen = "Break Ice"
                        //model.heightModel = selectedeHeight
                        goWhenTrue = true
                        
                        
                    } label: {
                        
                        Text("Next")
                        
                    }
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

//struct HeightPreferencesView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeightPreferencesView()
//    }
//}
