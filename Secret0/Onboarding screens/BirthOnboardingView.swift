//
//  BirthOnboardingView.swift
//  Pods
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct BirthOnboardingView: View {
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    // @AppStorage("onboardingScreen") var onboardingScreen: String?
    //var screen: onboardingScreen
    
    @State var birthDate = Date()
    @State var goWhenTrue : Bool = false
    @State var selection: Int? = nil
    
    @State var index : Int
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    Spacer()
                    
                    //let index = model.onboardingIndex
                    Image(systemName: Constants.screens[index].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .center)

                    
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        Text(Constants.screens[index].title)
                            .font(.title)
                            .bold()
                        
                        
                        DatePicker("",selection: $birthDate, displayedComponents: [.date])
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                        
                        
                        Text(Constants.screens[index].disclaimer)
                            .font(.caption)
                    }
                    .padding()
                    
                    NavigationLink(destination: NotifOnboarding(index: index+1)
                                    .environmentObject(ContentModel()), tag: 1, selection: $selection) {
                        Button(action: {
                            self.selection = 1
                            
                            if userOver18() {
                                //save birthdate into model
                                //model.birthdate = birthDate
                                saveDataHere()
                                
                                isOnboarding = true
                                
                                //save birthdate into core data
                                
                                
                            }
                        }) {
                            Text("Next")
                                //.bold()
                                .accentColor(.red)
                                .font(.title)
                        }
                        .padding()
                        .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)
                    }
                    
                    Button {
                        //sign out the user
                        try! Auth.auth().signOut() //we're using try because we're not interested to catch an error when signin out
                        
                        isOnboarding = false
                        //change to log out view
                        model.checkLogin()
                        
                    } label: {
                        Text("Sign Out")
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    func userOver18() -> Bool {
        
        let age = Calendar.current.dateComponents([.year, .month, .day], from: birthDate, to: Date())
        
        
        if age.year! > 17 {
            return true
        } else {
            return false
        }
    }
    
    
    //save data to firebase
    func saveDataHere() {
        
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user //user =  the current user using the app right now
            user.birthdate = birthDate //save to firebase user the values saved in the content model
            
            //save to the db
            let db = Firestore.firestore()
            let ref = db.collection("users").document(user.name)
            ref.setData(["birthdate" : user.birthdate], merge: true)
        }
    }
}



struct BirthOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BirthOnboardingView(index: 2)
    }
}
