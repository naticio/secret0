//
//  LocationOnboarding.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/29/21.
//

import SwiftUI
import CoreLocation
import FirebaseAuth
import Firebase

struct LocationOnboarding: View {
    
    @EnvironmentObject var model: ContentModel
    @EnvironmentObject var localizationModel: LocationModel //jala las func de localizacion
    
    //@State var location: String = ""
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @State var goWhenTrue : Bool = false
    
    @State private var deniedLocation = false
    
    @State var index : Int
    
    //    init() {
    //        localizationModel.requestGeolocationPermission()
    //    }
    
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
                    
                    //MAP USER. how to do this???
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                
                
                Spacer()
                
                NavigationLink(destination: genderOnboarding(index: index + 1)
                                .environmentObject(ContentModel()), isActive: $goWhenTrue) {
                    //ONBOARIDNG NEXT BUTTON
                    Button(action: {
                        //save username (to create user once we have password and email
                        
                        if localizationModel.authorizationState == .notDetermined {
                            // If undetermined, show onboarding
                            goWhenTrue = false
                        }
                        else if localizationModel.authorizationState == .authorizedAlways ||
                                    localizationModel.authorizationState == .authorizedWhenInUse {
                            
                            saveDataHere()
                            
                            isOnboarding = true
                            goWhenTrue = true
                            
                            
                        }
                        else {
                            // If denied show denied view
                            self.deniedLocation.toggle()
                        }
                        
                        
                    }, label: {
                        Text("Next")
                        
                    })
                    .disabled(localizationModel.authorizationState == .notDetermined)
                    .sheet(isPresented: $deniedLocation, content: {
                        LocationDeniedView()
                    })
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
            user.location = localizationModel.userLocation //save to firebase user the values saved in the content model
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(loggedInUser.uid)
            ref.setData([
                "latitude" : String(user.location!.coordinate.latitude),
                "longitude" : String(user.location!.coordinate.longitude)
            ], merge: true)
        }
    }
}


//struct LocationOnboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationOnboarding()
//        //.environmentObject(localizationModel)
//    }
//}
