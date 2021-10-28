//
//  ChatRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatRow: View {
    
    @EnvironmentObject var chatModel: ChatsViewModel
    
    @State private var tabBar: UITabBar! = nil
    
    let message: Message
    var isMe:  Bool
    var profilePic: String
    
    var chatUser : User
    
    var body: some View {
        //chat bubble

        HStack {

            //right align if I sent the message
//            if isMe == true {} //puts the space on the left
            
            if isMe == true {
                Spacer()

            }
            HStack {
                if isMe == true {
                    if profilePic == "NoImage" {
                        Image(systemName: "person.fill")
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else {
 
                            NavigationLink(destination: ProfileView(profileUser: chatUser)
                                            .onAppear { self.tabBar.isHidden = true }     // !!
                                            .onDisappear { self.tabBar.isHidden = false } // !!
                                           , label: {
                                WebImage(url: URL(string: profilePic))
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            })
                        .background(TabBarAccessor { tabbar in   // << here !!
                            self.tabBar = tabbar
                        })
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
                
            }
           
            //if msg sent by another person then left aligned
            if isMe == false  { Spacer() }//put the space on the right
        }.padding()
    }
}

    struct TabBarAccessor: UIViewControllerRepresentable {
        var callback: (UITabBar) -> Void
        private let proxyController = ViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
                                  UIViewController {
            proxyController.callback = callback
            return proxyController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
        }

        typealias UIViewControllerType = UIViewController

        private class ViewController: UIViewController {
            var callback: (UITabBar) -> Void = { _ in }

            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if let tabBar = self.tabBarController {
                    self.callback(tabBar.tabBar)
                }
            }
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
