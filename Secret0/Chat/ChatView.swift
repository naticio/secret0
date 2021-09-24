//
//  ChatView.swift
//  Pods
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI

struct ChatView: View {
    
    @State var newMessageInput = ""
    
    var body: some View {
        NavigationView {
            VStack {
                //to programatically change the scroll position of a scroll view, similar to gemotry reader
                ScrollViewReader { scrollView in
                    ScrollView { //to scroll nicely
                        ForEach(sampleConversation, id: \.messageID) { message in
                            MessageRow(message: message) //send an instance of chatMessage model
                                //assign an id to each chat message for scroll view reader
                                //first index finds the actual index position of the message
                                .id(sampleConversation.firstIndex(of: message))
                            
                        }
                        //on appear shows the LAST message
                        .onAppear(perform: {scrollView.scrollTo(sampleConversation.count-1)})
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
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
