//
//  HomeView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/2/21.
//

import SwiftUI


struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {

        TabView {
            MatchView(index: 0)
                .onAppear() {
                    model.getMatches()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                        Text("Match")
                    }
                }
            
            ChatView()
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Chat")
                    }
                }
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
        }
//        .onAppear {
//            model.getMatches()
//        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            
            // Save progress to the database when the app is moving from active to background
            //model.saveData(writeToDatabase: true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
