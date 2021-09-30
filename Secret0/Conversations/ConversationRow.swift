//
//  ConversationRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import SwiftUI


struct ConversationRow: View {
    
    let chat: Conversation
    
    var body: some View {
        HStack(spacing: 20) {
            Image(chat.person1Img)
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(chat.person1name)
                            .bold()
                        Spacer()
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                            .foregroundColor(chat.hasUnreadMessage ? .blue : .gray)
                    }
                    
                    HStack {
                        Text(chat.messages.last?.text ?? "")
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                }
                
                Circle()
                    .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: 80)
    }
}



//struct ContentView_Previews: PreviewProvider {
//
//    static let chat = Conversation(id: "1234", parties: [String]: ["test"],
//                           messages: [Message("Hey flo, how are you?", type: .Received)],
//                           hasUnreadMessage: true)
//
//    static var previews: some View {
//        ConversationRow(chat: chat)
//            .padding(.horizontal)
//    }
//}
