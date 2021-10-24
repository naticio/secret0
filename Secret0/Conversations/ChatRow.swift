//
//  ChatRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI

struct ChatRow: View {
    
    @EnvironmentObject var chatModel: ChatsViewModel
    
    let message: Message
    var isMe:  Bool
    var profilePic: String
 
    
    var body: some View {
        //chat bubble

        HStack {

            //right align if I sent the message
            if isMe == true {Spacer()} //puts the space on the left
            
            if isMe == true {
                if profilePic == "NoImage" {
                    Image(systemName: "person.fill")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    RemoteImage(url: profilePic)
                        //.resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }

            }
            
            VStack(alignment: .leading) {
                
                //sender
                Text(message.createdBy!)
                    .font(.footnote)
                    .foregroundColor(isMe ? .white : .gray)
                //message
                Text(message.msg!)
                    .font(.body)
                    .foregroundColor(isMe ? .white : .black)
                    .lineLimit(nil)
            }
            //create the bubble effect
            .padding(10)
            //if sent by me then color red
            .background(isMe ? Color.blue : Color("LightGrayColor"))
            .cornerRadius (10)
            .frame(maxWidth: 280, alignment: isMe ? .trailing : .leading)
            
            //if msg sent by another person then left aligned
            if isMe == false  { Spacer() }//put the space on the right
        }.padding()
    }
}


//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        //use seconfd dummy chat messafe from the chatmessage model
//        ChatRow(message: "text test", isMe: false)
//    }
//}


//struct ChatRow: View {
//    var body: some View {
//        HStack {
//            Image(systemName: "person")
//                .resizable()
//                .frame(width: 70, height: 70)
//                .clipShape(Circle())
//
//            ZStack {
//                VStack(alignment: .leading, spacing: 5){
//                    HStack {
//                        Text("Nat")
//                            .bold()
//                        Spacer()
//                        Text("Date")
//                    }
//
//                    HStack {
//                        Text("dhfkjhsfkjhsdfkjhdskjfhdkjfhdksjhfksdjzhf")
//                            .foregroundColor(.gray)
//                            .lineLimit(2)
//                            .frame(height:50, alignment: .top)
//                            .padding(.trailing,40)
//                    }
//                }
//            }
//        }
//        .frame(height:80)
//    }
//
//}
//
//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow()
//    }
//}
