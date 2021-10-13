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
    @State var messagesSnapshot = [Message]()
    
    @State var newMessageInput = ""
    
    var body: some View {
        NavigationView {
            VStack {
                //to programatically change the scroll position of a scroll view, similar to gemotry reader
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) { //to scroll
                        ForEach(chat.messages, id: \.id) { message in
                            if user.name == message.createdBy {
                                ChatRow(message: message, isMe: false)
                                    //.id(message.id)
                                    .id(chat.messages.firstIndex(of: message))
                                
                            } else {
                                ChatRow(message: message, isMe: true)
                                    .id(chat.messages.firstIndex(of: message))
                            }
                            
                        }
                        //on appear shows the LAST message
                        .onAppear(perform: {
                            scrollView.scrollTo(chat.messages.count-1)
                        })
                        .onChange(of: chat.messages.count, perform: { _ in
                            scrollView.scrollTo(chat.messages.endIndex)
                        })
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
                            //messagesSnapshot.append(Message(createdBy: user.name, msg: newMessageInput, date: Timestamp(), id: "test" ))
                            chatModel.sendMessageChat(newMessageInput, in: chat, chatid: chat.id ?? "")
                            print("Send message.")
                            //perform: {scrollView.scrollTo(chat.messages.count-1)}
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
        
        //        .onAppear() {
        //            //get all messages from the conversation collection
        //            chatModel.getMessages(chatId: chat.id!)
        //        }
        //
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: sampleConv)
//    }
//}
