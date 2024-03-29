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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var chatModel: ChatsViewModel
    
    let chat: Conversation
    //var userChat: User = User()
    
    let user = UserService.shared.user
    @State var messagesSnapshot = [Message]()
    
    @State var newMessageInput = ""
    
    var chatUser: String {
        if user.name == chat.users[0] {
            return chat.users[1]
           } else {
               return chat.users[0]
           }
       }
    
    var backButton : some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                    Text(chatUser)
                }
            }
        }
    
    var profilePic : String {
        //if I created the conversation
        
        if chat.profilePics.count > 1 { //no pics
            if user.name == chat.users[0] {
                    return chat.profilePics[1]
               } else {
                   return chat.profilePics[0]
               }
        }
        return "NoImage"

    }
    
    var body: some View {
        NavigationView {
            VStack {
                //to programatically change the scroll position of a scroll view, similar to gemotry reader
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) { //to scroll
                        ForEach(chat.messages, id: \.id) { message in
                            if user.name == message.createdBy {
                                ChatRow(message: message, isMe: true, profilePic: profilePic, chatUser: chatModel.userChat)
                                    //.id(message.id)
                                    .id(chat.messages.firstIndex(of: message))
                                
                            } else {
                                ChatRow(message: message, isMe: false, profilePic: profilePic, chatUser: chatModel.userChat)
                                    .id(chat.messages.firstIndex(of: message))
                            }
                            
                        }
                        //on appear shows the LAST message
                        .onAppear(perform: {
                            scrollView.scrollTo(chat.messages.count-1)
                            //scrollView.scrollTo(chat.messages.endIndex)
                        })
                        .onChange(of: chat.messages.count, perform: { _ in
                            scrollView.scrollTo(chat.messages.endIndex)
                        })
                    }
                }
                Spacer()
                
                //SEND A MESSAGE
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
                        .disableAutocorrection(true)
                        .padding(30)
                        
                        //send button
                        Button(action: {
                            //messagesSnapshot.append(Message(createdBy: user.name, msg: newMessageInput, date: Timestamp(), id: "test" ))
                            chatModel.sendMessageChat(newMessageInput, in: chat, chatid: chat.id ?? "")
                            print("Send message.")
                            newMessageInput = ""
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            //.navigationBarHidden(true)
//            .navigationTitle(chatUser)
//            .navigationBarTitle(chatUser, displayMode: .inline)
            //.navigationTitle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Title@*/Text("Title")/*@END_MENU_TOKEN@*/)
            //.edgesIgnoringSafeArea(.all)
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        
                .onAppear() {
                    //get profile of the person Im chatting with so I can show PROFILE when I lcik pic
                    if UserService.shared.user.name == chat.users[0] {
                        chatModel.getProfileUser(username: chat.users[1])
                    } else {
                        chatModel.getProfileUser(username: chat.users[0])
                    }
                    
                    chatModel.markAsUnread(chat: chat)
                }
        
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: sampleConv)
//    }
//}
