//
//  ChatsViewModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatsViewModel: ObservableObject {
    
    //gets assigned an arrat of dummy chats
    ///FETCH DATA FROM FIREBASE HERE, GET CHATS from x user, or on appear
    //@Published var chats = Conversation.sampleChat
    @Published var chats = [Conversation]()
    @Published var chatsRetrieved = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser

    
    func startConversation(receiver: String, message: String) {
        
        var ref: DocumentReference? = nil
        if (user != nil) {
            ref = db.collection("conversations").addDocument(data: ["users" : [user!.displayName, receiver],
                                                                    "messages":["created_by" : user!.displayName, "msg" : message, "date" : Date()]]) { err in
                if let err = err {
                    print("error writing doc")
                } else {
                    print("success writing conversation/chat")
                }
            }
            
            //write the message in the subcollection
//            db.collection("conversations").document(ref!.documentID).collection("messages").addDocument(data: [
//                "created_by" : user!.displayName ?? "",
//                "msg": message,
//                "date": Date()
//            ]){ errormsg in
//                if let error = errormsg {
//                    print("error writing message")
//                } else {
//                    print("success writing message")
//                }
//            }
        }
    }
    
    func sendMessageChat(_ text: String, in chat: Conversation, chatid: String) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(createdBy: user!.displayName, msg: text, date: Date())
            //chats[index].messages.append(message)
            //chats[index].messages.append([user!.displayName])
            
            //call firebase add message
            let ref = db.collection("conversations").document(chat.id!)
            //ref.setData(["gender" : user.gender], merge: true)
            ref.setData(["messages":["created_by" : user!.displayName, "msg" : message, "date" : Date()]], merge: false)
            
            return message
        }
        return nil
    }
    
    func markAsUnread(_ newValue: Bool, chat: Conversation) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    //return an array of chats
    func getFilteredConversations(query: String) {
        
        //let currentUser = UserService.shared.user
        if (user != nil) {
            db.collection("conversations").whereField("users", arrayContains: user!.displayName).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("no conversations found")
                    return
                }
                
                
                //mapping
                self.chats = documents.compactMap{(queryDocumentSnapshot) -> Conversation? in
                    //same as below but simpler, shorter
                    //return try? queryDocumentSnapshot.data(as: Conversations.self)

                    
                    let data = queryDocumentSnapshot.data()
                    let docId = queryDocumentSnapshot.documentID
                    let users = data["users"] as? [String] ?? [""]
                    let msgs = data["messages"] as? [Message] ?? []
                    let unreadmsg = data["hasUnreadMessage"] as? Bool ?? false
                    
                    print("Users: \(users)")
                    
                    //let unreadMsg = data["unreadMsg"] as? Bool ?? false
                    
                    //chatsRetrieved = true //so I don't execute this again
                    //not getting messaages until chat is clicked
                    return Conversation(id: docId, users: users, messages: msgs, hasUnreadMessage: unreadmsg)
                    
                }
                
                /* FAILED ATTEMPT
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
            }
        }
        
        
        //search for chats, hinge doesn't have it
        //        return sortedChats.filter { $0.person.name.lowercased().contains(query.lowercased()) }
    }

    
    
    func getSectionMessages(for chat: Conversation) -> [[Message]] {
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
