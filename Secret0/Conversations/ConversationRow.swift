//
//  ConversationRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import SwiftUI
import SDWebImageSwiftUI


struct ConversationRow: View {
    
    let chat: Conversation
    
    var body: some View {
        HStack(spacing: 20) {
            //if current user == sender or creator of the conversation
            if UserService.shared.user.name == chat.users[0] {
                //show image of other person, 2nd index aka index 1
                if chat.profilePics.count == 1 {
                    Image(systemName: "person.fill")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    WebImage(url: URL(string: chat.profilePics[1]))
                        //.resizable()
//                        .frame(width: 70, height: 70)
//                        .scaledToFill()
//                        .cornerRadius(10)
//                        .clipShape(Circle())
//                        .padding(10)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())

                }

            } else {
                
                if chat.profilePics.count == 1  {
                    Image(systemName: "person.fill")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    //show image of other person, 1st index aka index 0
                    //Image(chat.users[0].imageUrl)
                    WebImage(url: URL(string: chat.profilePics[0]))
                        //.resizable()
//                        .frame(width: 70, height: 70)
//                        .aspectRatio(contentMode: .fit)
//                        .scaledToFill()
//                        .cornerRadius(10)
//                        .clipShape(Circle())
//                        .padding(10)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }

            }

            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        //if current user created the conversation
                        if UserService.shared.user.name == chat.users[0] {
                            //if I created the conversation show me the other person name
                            Text(chat.users[1])
                                .bold()
                        } else {
                            Text(chat.users[0])
                                .bold()
                        }

                        Spacer()
                        //Text(chat.messages.last?.date.descriptiveString() ?? "")
                            //.foregroundColor(chat.hasUnreadMessage ? .blue : .gray)
                    }
                    
                    HStack {
                        Text(chat.messages.last?.msg ?? "")
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                }
                //MARK: - unread message - NEW MESSAGE INDICATOR OR UNREAD MSG
                Circle()
                    .foregroundColor(chat.hasUnreadMessage && chat.lastSender != UserService.shared.user.name ? .red : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    //.background(chat.hasUnreadMessage ? Color.red : Color.black)
            }
        }
        .frame(height: 80)
    }
}



//struct ContentView_Previews: PreviewProvider {
//
//    static let chat = Conversation(id: "1", users: ["Lola", "Adal"], messages: [Message])
//
//    static var previews: some View {
//        ConversationRow(chat: chat)
//            .padding(.horizontal)
//    }
//}
