//
//  SexOnboardingView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/30/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

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
                
                
                Picker("", selection: $selectedPref) {
                    ForEach(0..<preferences.count) { index in
                        Text(self.preferences[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                
                
                NavigationLink(destination: DatePreferencesView(index: index + 1)
                                .environmentObject(ContentModel())
                               , isActive: $goWhenTrue) {
                    //BUTTON NEXT
                    Button {
                        saveDataHere()
                        
                        isOnboarding = true
                        //onboardingScreen = "Dating"
                        goWhenTrue = true
                        
                        
                    } label: {
                        
                        Text("Next")
                            .accentColor(.red)
                            .font(.title)
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
    
    
    //save data to firebase
    func saveDataHere() {
        
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user //user =  the current user using the app right now
            user.sexuality = selectedPref //save to firebase user the values saved in the content model
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(loggedInUser.uid)
            ref.setData(["sexuality" : user.sexuality], merge: true)
        }
    }
}




struct SexOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SexOnboardingView(index: 6)
            .environmentObject(ContentModel())
    }
}
