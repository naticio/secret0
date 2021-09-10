//
//  genderOnboarding.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/30/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct genderOnboarding: View {
    
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    @State private var maleButtonPressed:Bool = false
    @State private var femaleButtonPressed:Bool = false
    @State var selectedGender: String = ""
    
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
                        Text("Men")
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
                        Text("Women")
                    }
                    .padding()
                    .background(femaleButtonPressed ? Color.red : Color.white)
                    .frame(width: 100)
                    .cornerRadius(10.0)
                }
                
                
                
                Spacer()
                
                NavigationLink(destination: SexOnboardingView(index: index + 1)
                                .environmentObject(ContentModel())
                               , isActive: $goWhenTrue) {
                    //ONBOARIDNG NEXT BUTTON
                    Button(action: {
                        if maleButtonPressed == true || femaleButtonPressed == true {
                            if maleButtonPressed == true {selectedGender = "Men"}
                            if femaleButtonPressed == true {selectedGender = "Women"}
                            
                            
                            saveDataHere()
                            
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
                    
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    //save data to firebase
    func saveDataHere() {
    
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user //user =  the current user using the app right now
            user.gender = selectedGender //save to firebase user the values saved in the content model
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(loggedInUser.uid)
            ref.setData(["gender" : user.gender], merge: true)
        }
    }
}

//struct genderOnboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        genderOnboarding()
//    }
//}
