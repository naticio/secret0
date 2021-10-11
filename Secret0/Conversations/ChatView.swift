//
//  ChatView.swift
//  Secret0
//
//  Created by Nat-Serrano on 10/10/21.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatView: View {
    

    @EnvironmentObject var chatModel: ChatsViewModel
    
    let chat: Conversation
    let user = UserService.shared.user
    
    @State var newMessageInput = ""
    
    var body: some View {
        NavigationView {
            VStack {
                //to programatically change the scroll position of a scroll view, similar to gemotry reader
                ScrollViewReader { scrollView in
                    ScrollView { //to scroll nicely
                        //sort by date
                        //let sortedMsgs = chatModel.msgs.sorted(by: { $0.date > $1.date })
                        ForEach(chatModel.msgs, id: \.id) { message in
                            //if current user == whoever sent the message
                            if user.name == message.createdBy {
                                ChatRow(message: message, isMe: true) //send an instance of chatMessage model
                                    //assign an id to each chat message for scroll view reader
                                    //first index finds the actual index position of the message
                                    //.id(chatModel.msgs.firstIndex(of: message))
                            } else {
                                ChatRow(message: message, isMe: false)
                                    //.id(chatModel.msgs.firstIndex(of: message))
                            }

                            
                        }
                        //on appear shows the LAST message
                        .onAppear(perform: {scrollView.scrollTo(chatModel.msgs.count-1)})
                    }
                    
                }
                Spacer()
                
                //send a new message
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                    
                    //to make it prettier
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("LightGrayColor"), lineWidth: 2)
                        .padding()
                    
                    //input binding to state var so everytime it changes binds
                    HStack {
                        TextField("New message...", text: $newMessageInput, onCommit: {
                            print("Send Message")
                        })
                        .padding(30)
                        
                        //send button
                        Button(action: {
                            chatModel.sendMessageChat(newMessageInput, in: chat, chatid: chat.id ?? "")
                            print("Send message.")
                        }) {
                            Image(systemName: "paperplane")
                                .imageScale(.large)
                                .padding(30)
                        }
                    }
                }
                .frame(height: 70)
            }
            .navigationTitle("Chat")
        }
        .onAppear() {
            //get all messages from the conversation collection
            chatModel.getMessages(chatId: chat.id!)
        }
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chat: sampleConv)
    }
}
