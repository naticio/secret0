//
//  ChatView.swift
//  Pods
//
//  Created by Nat-Serrano on 9/29/21.
//

import SwiftUI


struct ChatView: View {
    
    @EnvironmentObject var chatModel: ChatsViewModel
    
    let chat: Conversation
    
    @State private var text = ""
    //@FocusState private var isFocused
    
    @State private var messageIDToScroll: UUID?
    
    let spacing: CGFloat = 10
    let minSpacing: CGFloat = 3
    
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { reader in
                getChatsView(viewWidth: reader.size.width)
                    .onTapGesture {
                        //isFocused = false
                    }
            }
            .padding(.bottom, 5)
            
            //SEND MESSAGE button
            toolbarView()
        }
        .padding(.top, 1)
        .navigationBarItems(leading: navBarLeadingBtn(), trailing: navBarTrailingBtn())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            chatModel.markAsUnread(false, chat: chat)
        }
    }
    
    
    func getChatsView(viewWidth: CGFloat) -> some View {
        ScrollView {
            ScrollViewReader { scrollReader in
                LazyVGrid(columns: [GridItem(.flexible(minimum: 0))], spacing: 0, pinnedViews: [.sectionHeaders]) {
                    let sectionMessages = chatModel.getSectionMessages(for: chat)
                    ForEach(sectionMessages.indices, id: \.self) { i in
                        let messages = sectionMessages[i]
                        Section(header: sectionHeader(firstMessage: messages.first!)) {
                            ForEach(messages) { message in
                                let isReceived = message.type == .Received
                                
                                HStack {
                                    ZStack {
                                        Text(message.text)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                            .background(isReceived ? Color.black.opacity(0.2) : Color.green.opacity(0.9))
                                            .cornerRadius(13)
                                    }
                                    .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading  : .trailing)
                                    .padding(.vertical, 5)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: isReceived ? .leading  : .trailing)
                                .id(message.id)
                            }
                        }
                    }
//                    .onChange(of: isFocused) { _ in
//                        if isFocused {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                                withAnimation(.easeIn(duration: 0.5)) {
//                                    scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
//                                }
//                            }
//                        }
//                    }
                    .onChange(of: messageIDToScroll) { _ in
                        // This scrolls down to the new sent Message
                        if let messageID = messageIDToScroll {
                            DispatchQueue.main.async {
                                withAnimation(.easeIn) {
                                    scrollReader.scrollTo(messageID)
                                }
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.white)
    }
    
    func toolbarView() -> some View {
        VStack {
            let height: CGFloat = 37
            HStack {
                if #available(iOS 15.0, *) {
                    TextField("Write something nice...", text: $text)
                        .padding(.horizontal, 10)
                        .frame(height: height)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                        //.focused($isFocused)
                } else {
                    // Fallback on earlier versions
                }
                
                //send message BUTTON
                Button(action: {
                    if let newMessage = chatModel.sendMessage(text, in: chat) {
                        text = ""
                        messageIDToScroll = newMessage.id
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: height, height: height)
                        .background(
                            Circle()
                                .foregroundColor(text.isEmpty ? .gray : .blue)
                        )
                }
            }
            .frame(height: height)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        //.background(.thickMaterial)
    }
    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            let color = Color(hue: 0.587, saturation: 0.742, brightness: 0.924)
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 4)
                .background(Capsule().foregroundColor(color))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
    
    func navBarLeadingBtn() -> some View {
        Button(action: {}) {
            HStack {
                if UserService.shared.user.name == chat.users[0] {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(chat.users[1])
                        .bold()
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(chat.users[0])
                        .bold()
                }
                

            }
            .foregroundColor(.black)
        }
    }
    
    func navBarTrailingBtn() -> some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "video")
            }
            
            Button(action: {}) {
                Image(systemName: "phone")
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chat: ChatsViewModel().chats[0])
        }
    }
}
