//
//  Conversations.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import SwiftUI

struct ConversationsView: View {
    
    @ObservedObject var chatModel = ChatsViewModel()
    
    @State private var query = ""

    //@available(iOS 15.0, *)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chatModel.chats) { chat in
                    if #available(iOS 15.0, *) {
                        ZStack {
                            ConversationRow(chat: chat)
                            
                            // hidden NavigationLink. This hides the disclosure arrow!
                            NavigationLink(destination: ChatView(chat: chat).environmentObject(chatModel)) {}
                            .buttonStyle(PlainButtonStyle())
                            .frame(width:0)
                            .opacity(0)
                        }
//                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                            if #available(iOS 15.0, *) {
//                                Button(action: {
//                                    chatModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
//                                }) {
//                                    if chat.hasUnreadMessage {
//                                        Label("Read", systemImage: "text.bubble")
//                                    } else {
//                                        Label("Read", systemImage: "circle.fill")
//                                    }
//                                }
//                                .tint(.blue)
//                            } else {
//                                // Fallback on earlier versions
//                            }
//                        }
                    } else {
                        // Fallback on earlier versions
                        ZStack {
                            ConversationRow(chat: chat)
                            
                            // hidden NavigationLink. This hides the disclosure arrow!
                            NavigationLink(destination: ChatView(chat: chat)
                                            .navigationBarTitle("")
                                            .navigationBarHidden(true)
                                            .environmentObject(chatModel)) {}
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
        .onAppear() {
            //get conversations
            chatModel.getFilteredConversations(query: "")
            //chatModel.getProfileMatch(username: chatModel.chats[1].users[1])
        }
    }
}

struct Conversations_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ConversationsView()
            //.padding(.horizontal)
    }
}
