//
//  LaunchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import SwiftUI
import FirebaseAuth

struct LaunchLogicView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("onboardingScreen") var onboardingScreen: String?
    @StateObject var viewRouter = ViewRouter()
    @StateObject var chatViewModel = ChatsViewModel()
    @EnvironmentObject var model: ContentModel //because we depend on content model to know if user is loggedin (loggedin property)
    //let persistenceController = PersistenceController.shared
    
//    init(){
//        try! Auth.auth().signOut()
//    }
    
    var body: some View {
        
        
        
        if model.loggedIn == false {
            Index()
                .onAppear() {
                    model.checkLogin()
                }
        }
        else {
            if isOnboarding == true {
                BirthOnboardingView(index: 2)
                    .onAppear() {
                        model.checkLogin()
                    }
            }
            else if model.userDataCompletion == true {
                //TabView
                TabView {
                    MatchView(index: 0)
                        .onAppear() {
                            //if model.usersLoaded == false && model.loggedIn == true {
                                model.getMatchesNearMeDispatch(radius: 50)
                            //}
                            //get conversations
                            //chatViewModel.getFilteredConversations(query: "")
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "heart")
                                Text("Match")
                            }
                        }
                    
                    ConversationsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("Chat")
                            }
                        }
                    
                    ProfileView(profileUser: UserService.shared.user)
                        .tabItem {
                            VStack {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                        }
                }
//                .onAppear {
//                    model.getMatches()
//                }
            }
        }
        
        //        if model.loggedIn  == false && isOnboarding == false {
        //            WelcomeScreenView() // video with sign in - sign up options
        //                .onAppear {
        //                    //check if user is logged out
        //                    model.checkLogin()
        //                }
        //        } else {
        //            if model.loggedIn == true && isOnboarding == false {
        //                HomeView() //user logged in, tab view with matches
        //                    .onAppear() {
        //                        model.getUserData()
        //                        model.getMatches()
        //                    }
        //                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
        //            } else {
        //                BirthOnboardingView(index: 2)
        //                    .onAppear() {
        //                        //model.onboardingIndex = 2
        //                        model.checkLogin()
        //                    }
        //                    //save data when app is closed by user
        //                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in //willresign is whne you hidde the app or is out of focus
        //                        //save data is true
        //                        //model.saveUserData(writeToDatabase: true)
        //                    }
        //            }
        //
        //        }
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchLogicView()
    }
}
