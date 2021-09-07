//
//  DatePreferencesView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct DatePreferencesView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    //var screen: onboardingScreen
    
    @State var goWhenTrue : Bool = false
    @State var menPressed : Bool = false
    @State var womenPressed : Bool = false
    @State var everyOnePressed : Bool = false
    @State var datingPref: String = ""
    
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
                
                NavigationLink(destination: HeightPreferencesView(index: index + 1)
                                .environmentObject(ContentModel()), isActive: $goWhenTrue) {
                    //BUTTON NEXT
                    Button {
                        if menPressed == true || womenPressed == true || everyOnePressed == true {
                            if menPressed == true { datingPref = "Men" }
                            if womenPressed == true { datingPref = "Women" }
                            if everyOnePressed == true { datingPref = "Everyone" }
                            
                            saveDataHere()
                            
                            isOnboarding = true
                            //onboardingScreen = "Height"
                            goWhenTrue = true
                            
                        }
                        
                    } label: {
                        Text("Next")
                    }
                    .disabled(menPressed == false && womenPressed == false && everyOnePressed == false)
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
            user.datingPreferences = datingPref //save to firebase user the values saved in the content model
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(loggedInUser.uid)
            ref.setData(["datingPreferences" : user.datingPreferences], merge: true)
        }
    }
}

//struct DatePreferencesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePreferencesView()
//    }
//}
