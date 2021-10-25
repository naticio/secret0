//
//  HeightPreferencesView.swift
//  Pods
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct HeightOnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    //@State private var index: Int = 0
    @State var goWhenTrue : Bool = false
    @State var selectedeHeight: String = "5'7 (170 cm)"
    @State var heightOptions = [
        "4'9 (144 cm)",
        "4'10 (147 cm)",
        "4'11 (150 cm)",
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
    @State var selectedHeightNumber: Int = 170
    
    
    var body: some View {
        ZStack {
            VStack {
                
                //let index = model.onboardingIndex
                Spacer()
                
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)

                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                    
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                
                
                Picker("", selection: $selectedeHeight) {
                    ForEach(0..<heightOptions.count) { index in
                        Text(self.heightOptions[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                
                NavigationLink(destination: BreakIceOnboardingView(index: index + 1)
                                .environmentObject(ContentModel())
                                .navigationBarBackButtonHidden(true)
                               , isActive: $goWhenTrue) {
                    //BUTTON NEXT
                    Button {
                        if selectedeHeight.contains("144") { selectedHeightNumber = 57}
                        if selectedeHeight.contains("147") { selectedHeightNumber = 58}
                        if selectedeHeight.contains("150") { selectedHeightNumber = 59}
                        if selectedeHeight.contains("152") { selectedHeightNumber = 60}
                        if selectedeHeight.contains("155") { selectedHeightNumber = 61}
                        if selectedeHeight.contains("158") { selectedHeightNumber = 62}
                        if selectedeHeight.contains("160") { selectedHeightNumber = 63}
                        if selectedeHeight.contains("163") { selectedHeightNumber = 64}
                        if selectedeHeight.contains("165") { selectedHeightNumber = 65}
                        if selectedeHeight.contains("168") { selectedHeightNumber = 66}
                        if selectedeHeight.contains("170") { selectedHeightNumber = 67}
                        if selectedeHeight.contains("173") { selectedHeightNumber = 68}
                        if selectedeHeight.contains("175") { selectedHeightNumber = 69}
                        if selectedeHeight.contains("178") { selectedHeightNumber = 70}
                        if selectedeHeight.contains("180") { selectedHeightNumber = 71}
                        if selectedeHeight.contains("183") { selectedHeightNumber = 72}
                        if selectedeHeight.contains("185") { selectedHeightNumber = 73}
                        if selectedeHeight.contains("188") { selectedHeightNumber = 74}
                        if selectedeHeight.contains("190") { selectedHeightNumber = 75}
                        if selectedeHeight.contains("193") { selectedHeightNumber = 76}
                        if selectedeHeight.contains("195") { selectedHeightNumber = 77}
                        
                        
                        saveDataHere()
                        
                        isOnboarding = true
                        //onboardingScreen = "Break Ice"
                        //model.heightModel = selectedeHeight
                        goWhenTrue = true
                        
                        
                    } label: {
                        
                        Text("Next")
                            .accentColor(.red)
                            .font(.title)
                        
                    }
                    .padding()
                    .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                    .frame(width: 100)
                }
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    //save data to firebase
    func saveDataHere() {
    
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user //user =  the current user using the app right now
            user.height = selectedHeightNumber //save to firebase user the values saved in the content model
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(user.name)
            ref.setData(["height" : user.height], merge: true)
        }
    }
}

struct HeightOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        HeightOnboardingView(index: 8)
            .environmentObject(ContentModel())
    }
}
