//
//  Q1Day2LiveView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct OnboardingQuestions: View {
    
    @EnvironmentObject var model: ContentModel
    @StateObject var imageController = ImageController()
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var goWhenTrue : Bool = false
    @State var goWhenTrue2 : Bool = false
    @State private var response : String = ""
    
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
                
                //RESPONSE
                TextEditor(text: $response)
                    .multilineTextAlignment(.leading)
                    .frame(height: 400)
                    .cornerRadius(25)
                    .font(Font.custom("AvenirNext-Regular", size: 20, relativeTo: .body))
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .border(Color.gray, width: 3)
                    .padding()

                
                if index < Constants.screens.count-1 {
                    NavigationLink(destination: OnboardingQuestions(index: index + 1)
                                    .environmentObject(model), isActive: $goWhenTrue) {
                        //BUTTON NEXT
                        Button {
                            
                            saveDataHere()
                            
                            goWhenTrue = true
                            
                            response = ""
                            
                        } label: {
                            Text("Next")
                                .accentColor(.red)
                                .font(.title)
                        }
                        .padding()
                        .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                        .frame(width: 100)
                        
                    }
                } else if index == Constants.screens.count-1 {
                    NavigationLink(destination: PictureUploaderView()
                                    .environmentObject(imageController), isActive: $goWhenTrue2) {
                        //BUTTON NEXT
                        Button {
                            saveDataHere()
                            
                            response = ""
                            
                            goWhenTrue2 = true
                            
                            isOnboarding = true
                            //save all data from model to the db
                            
                            
                        } label: {
                            Text("Next")
                                .accentColor(.red)
                                .font(.title)
                        }
                        .padding()
                        .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                        .frame(width: 100)
                    }
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
            
            if Constants.screens[index].title.contains("one day left") {
                user.Q1day2live = response
                
                let db = Firestore.firestore()
                let ref = db.collection("users").document(user.name)
                ref.setData(["Q1day2live" : user.Q1day2live], merge: true)
            }
            if Constants.screens[index].title.contains("100,000,000") {
                user.QlotteryWin = response
                
                let db = Firestore.firestore()
                let ref = db.collection("users").document(user.name)
                ref.setData(["QlotteryWin" : user.QlotteryWin], merge: true)
            }
            if Constants.screens[index].title.contains("money didn't matter") {
                user.QmoneynotanIssue = response
                
                let db = Firestore.firestore()
                let ref = db.collection("users").document(user.name)
                ref.setData(["QmoneynotanIssue" : user.QmoneynotanIssue], merge: true)
            }
            if Constants.screens[index].title.contains("bucket list") {
                user.bucketList = response
                
                let db = Firestore.firestore()
                let ref = db.collection("users").document(user.name)
                ref.setData(["bucketList" : user.bucketList], merge: true)
            }
            if Constants.screens[index].title.contains("Jokes") {
                user.jokes = response
                
                let db = Firestore.firestore()
                let ref = db.collection("users").document(user.name)
                ref.setData(["jokes" : user.jokes], merge: true)
            }
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

struct Q1Day2LiveView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingQuestions(index: 10)
            .environmentObject(ContentModel())
    }
}
