//
//  ChatsViewModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatsViewModel: ObservableObject {
    
    //gets assigned an arrat of dummy chats
    ///FETCH DATA FROM FIREBASE HERE, GET CHATS from x user, or on appear
    //@Published var chats = Conversation.sampleChat
    @Published var chats = [Conversations]()
    @Published var chatsRetrieved = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func sendMessage(_ text: String, in chat: Conversations) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(text, type: .Sent)
            //chats[index].messages.append(message)
            //chats[index].messages.append([user!.displayName])
            
            //call firebase add message
            let ref = db.collection("conversations").document(chat.id)
            //ref.setData(["gender" : user.gender], merge: true)
            ref.setData(["messages" : [user!.displayName : text]], merge: true)
            
            return message
        }
        return nil
    }
    
    func markAsUnread(_ newValue: Bool, chat: Conversations) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    //return an array of chats
    func getFilteredConversations(query: String) {
        
        //let currentUser = UserService.shared.user
        if (user != nil) {
            db.collection("conversations").whereField("users", arrayContains: user!.displayName).addSnapshotListener({ [self](snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no conversations found")
                    return
                }
                
                var chatshere = [Conversations]()
                
                for doc in snapshot!.documents {
                    var conver = [Conversations]() //empty array of conversation
                    conver.id = doc["id"] as? String ?? ""
                    conver.users = doc["users"] as? [String] ?? [""]
                    //conver.messages = doc["messages"] as? [Message] ?? []
                    conver.hasUnreadMessage = doc["hasUnreadMessage"] as? Bool ?? false
                    
                    
                    chatshere.append(conver)
                    
                }
                
                DispatchQueue.main.async {
                    self.chats = chatshere
                    //self.usersLoaded = true
                }
                
                /*mapping OLD WAY
                 self.chats = documents.map{(docSnapshot) -> Conversation in
                 let data = docSnapshot.data()
                 
                 let docId = docSnapshot.documentID
                 let users = data["users"] as? [String] ?? [""]
                 //                        let p1Img = data["person1Img"] as? String ?? ""
                 //                        let p2Img = data["person2Img"] as? String ?? ""
                 //                        let p1name = data["person1name"] as? String ?? ""
                 //                        let p2name = data["person2name"] as? String ?? ""
                 let msgs = data["messages"] as? [Message] ?? []
                 
                 print("Users: \(users)")
                 
                 //let unreadMsg = data["unreadMsg"] as? Bool ?? false
                 
                 chatsRetrieved = true //so I don't execute this again
                 //not getting messaages until chat is clicked
                 return Conversation(id: docId, users: users, messages: msgs)
                 }*/
                //
                //                let sortedChats = chats.sorted {
                //                    guard let date1 = $0.messages.last?.date else { return false }
                //                    guard let date2 = $1.messages.last?.date else { return false }
                //                    return date1 > date2
                //                }
                //
                //                if (query == "") {
                //                    return sortedChats
                //                }
            })
        }
        
        
        //search for chats, hinge doesn't have it
        //        return sortedChats.filter { $0.person.name.lowercased().contains(query.lowercased()) }
    }
    
    func startConversation(receiver: String, message: String) {
        
        var ref: DocumentReference? = nil
        if (user != nil) {
            ref = db.collection("conversations").addDocument(data: ["users" : [user!.displayName, receiver],
                                                                    "messages" : [user!.displayName, message]]) { err in
                if let err = err {
                    print("error writing doc")
                } else {
                    print("success writing conversation/chat")
                }
            }
            
            //write the message
            db.collection("conversations").document(ref!.documentID).collection("messages").addDocument(data: [
                "from" : user!.displayName ?? "",
                "message": message
            ]){ errormsg in
                if let error = errormsg {
                    print("error writing message")
                } else {
                    print("success writing message")
                }
            }
        }
    }
    
    
    func getSectionMessages(for chat: Conversations) -> [[Message]] {
        var res = [[Message]]()
        var tmp = [Message]()
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date ?? Date())
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                } else {
                    tmp.append(message)
                }
            } else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        
        return res
    }
}




//extension Conversation {
//
//    static let sampleChat = [
//        Conversation(person: Person(name: "Hakim", imgString: "img1"), messages: [
//            Message("Hey Hakim", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("I am just developing an WhatsApp Clone App and it is so hard to create a fake chat conversation. Can you help me out with it?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("Please I need your help 😔", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("Sure how can I help you flo?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("Maybe you send me some \"good\" jokes 😅", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("Sure I can do that. No problem 😂😂", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("What do you call a fish with no eyes?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("Hmm, Idk", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("A fsh", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("OMG so bad 😂😂", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("Let me try one", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("There are 10 types of people in this world, those who understand binary and those who don't", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("This joke is sooo old haha", type: .Received, date: Date()),
//        ], hasUnreadMessage: true),
//
//        Conversation(person: Person(name: "Vladimir W.", imgString: "img6"), messages: [
//            Message("Hey Vlad, how is your bootcamp going?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 5)),
//            Message("It's going great flo. I have just finished my first app, but I still have a lot to learn, but coding is so much fun. I love it :)", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("Hey that sounds great. Congratulations Vlad 🥳", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("What type of app is it?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("It's a Table App. I have coded it for the bootcamp, so that I get more familiar with SwiftUI.", type: .Received, date: Date()),
//            Message("The big question now is if I should start a junior dev job or if I should do app development just for fun.", type: .Received, date: Date()),
//        ]),
//
//        Conversation(person: Person(name: "Andrej", imgString: "img7"), messages: [
//            Message("Hey Sensei 👋", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("Can you show me a new Meditation exercise? The last one was so helpfull ☺️", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
//            Message("Yeah sure flo. Have you tested the mindful breathing techniques yet?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("No what is that?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("This technique can increase your energy and help you to feel more alert.", type: .Received),
//        ], hasUnreadMessage: true),
//
//        Conversation(person: Person(name: "Romesh", imgString: "img9"), messages: [
//            Message("Hey Romesh, how is your dev journey going?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
//            Message("Thanks for asking flo. It is going great. I just completed the HWS course. I have learned so much an now I am starting to building my own app.", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)),
//            Message("That sounds great. I'm so proud of you, that you completed the course. Most people don't have the endurance to complete it, because the cannot sit with the problem long enough. So you can definetly see this as an archievment ☺️💪", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2))
//        ]),
//
//        Conversation(person: Person(name: "Dirk S.", imgString: "img8"), messages: [
//            Message("Hey Dirk, are you from germany?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("Hey Flo, yes I am.", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("Ohh thats cool, how is your dev journey going?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("SwiftUI is just amazing, it makes coding so fast and elegant. I have currently completed the 100 days of SwiftUI course from Paul Hudson. The course was awesome and I learned so much 😃", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
//            Message("Nice Dirk, Congratulations for completing the course. Yeah you are right, I also love developing apps in SwiftUI, because you can do so much crazy stuff with just a few lines of code.", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//            Message("SwiftUI is a real game changer for IOS Development 😍", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
//        ]),
//
//        Conversation(person: Person(name: "Sandeep", imgString: "img2"), messages: [
//            Message("Hey buddy, what are you doing?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 10)),
//            Message("I'm just learning SwiftUI. Do you know the awesome online course called Hacking With SwiftUI?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 10)),
//            Message("Oh yeah, this course is awesome. I have completed it and I can fully recommend it as well 🙏", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 9)),
//        ]),
//
//        Conversation(person: Person(name: "Wayne D.", imgString: "img3"), messages: [
//            Message("Hey Wayne, I just want to say thank you so much for your support on Patreon 🙏", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
//            Message("I hope you will read this ☺️", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
//        ]),
//    ]
//}
