//
//  BirthOnboardingView.swift
//  Pods
//
//  Created by Nat-Serrano on 8/28/21.
//

import SwiftUI
import FirebaseAuth

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
                        

                        DatePicker("",selection: $birthDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                    
                        
                        Text(Constants.screens[index].disclaimer)
                            .font(.caption)
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: NotifOnboarding(index: index+1)
                                    .environmentObject(ContentModel()), tag: 1, selection: $selection) {
                        Button(action: {
                            self.selection = 1
                            
                            if userOver18() {
                                //save birthdate into model
                                model.birthdate = birthDate
                                isOnboarding = true
                                //onboardingScreen = "Notifications"
                                
                                //update indexes
//                                if model.onboardingIndex < Constants.screens.count-1 {
//                                    model.onboardingIndex += 1
//
//                                }
                            }
                        }) {
                                Text("Next")
                        }
                        .accentColor(Color.red)
                        .padding()
                        .background(Color(UIColor.red))
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
                    
    //                Button(action: {
    //                    //save username (to create user once we have password and email
    //                    goWhenTrue = true
    //
    //                    if userOver18() {
    //                        //save birthdate into model
    //                        model.age = birthDate
    //                        isOnboarding = true
    //                        //onboardingScreen = "Notifications"
    //
    //
    //
    //                        //update indexes
    //                        if model.onboardingIndex < Constants.screens.count-1 {
    //                            model.onboardingIndex += 1
    //
    //                        }
    //                    }
    //
    //                }, label: {
    //                    if model.onboardingIndex == Constants.screens.count {
    //                        Text("Done")
    //                    } else {
    //                        Text("Next")
    //                    }
    //
    //                })
    //                .padding()
    //                .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
    //                .frame(width: 100)
                   
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
}

//struct BirthOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BirthOnboardingView()
//    }
//}
