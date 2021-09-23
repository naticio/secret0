//
//  ChatRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI

struct ChatRow: View {
    
    let message: ChatMessage
    
    var body: some View {
        //chat bubble
        
        HStack {
            //right align if I sent the message
            if message.isMe {
                   Spacer() //puts the space on the left
               }
            
            VStack(alignment: .leading) {
                //sender
                Text(message.username)
                    .font(.footnote)
                    .foregroundColor(message.isMe ? .white : .gray)
                //message
                Text(message.messageText)
                    .font(.body)
                    .foregroundColor(message.isMe ? .white : .black)
                    .lineLimit(nil)
            }
            //create the bubble effect
            .padding(10)
            //if sent by me then color red
            .background(message.isMe ? Color.blue : Color("LightGrayColor"))
            .cornerRadius (10)
            .frame(maxWidth: 280, alignment: message.isMe ? .trailing : .leading)
            
            //if msg sent by another person then left aligned
            if !message.isMe {
                    Spacer() //put the space on the right
                }
        }.padding()
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        //use seconfd dummy chat messafe from the chatmessage model
        ChatRow(message: sampleConversation[1])
    }
}
