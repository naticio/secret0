//
//  Conversations.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import SwiftUI

struct ConversationsView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    @State private var query = ""

    //@available(iOS 15.0, *)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.chats) { chat in
                    if #available(iOS 15.0, *) {
                        ZStack {
                            ConversationRow(chat: chat)
                            
                            // hidden NavigationLink. This hides the disclosure arrow!
                            NavigationLink(destination: ChatView(chat: chat).environmentObject(viewModel)) {}
                            .buttonStyle(PlainButtonStyle())
                            .frame(width:0)
                            .opacity(0)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if #available(iOS 15.0, *) {
                                Button(action: {
                                    viewModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                                }) {
                                    if chat.hasUnreadMessage {
                                        Label("Read", systemImage: "text.bubble")
                                    } else {
                                        Label("Read", systemImage: "circle.fill")
                                    }
                                }
                                .tint(.blue)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                        ZStack {
                            ConversationRow(chat: chat)
                            
                            // hidden NavigationLink. This hides the disclosure arrow!
                            NavigationLink(destination: ChatView(chat: chat).environmentObject(viewModel)) {}
                            .buttonStyle(PlainButtonStyle())
                            .frame(width:0)
                            .opacity(0)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            //.searchable(text: $query)
            .navigationTitle("Chats")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "square.and.pencil")
            })
        }
    }
}

struct Conversations_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ConversationsView()
            //.padding(.horizontal)
    }
}
