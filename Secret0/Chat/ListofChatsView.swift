//
//  ListofChatsView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI

struct ListofChatsView: View {
    var body: some View {
        NavigationView {
            List{
                ForEach(0 ..< 10) { i in
                    ChatRow()
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Chats")
            .navigationBarItems(trailing: Button(action: {}){
                Image(systemName: "square.and.pencil")
            })
        }
    }
}

struct ListofChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ListofChatsView()
    }
}
