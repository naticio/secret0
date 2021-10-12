//
//  ChatsViewModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatsViewModel: ObservableObject {
    
    //gets assigned an arrat of dummy chats
    ///FETCH DATA FROM FIREBASE HERE, GET CHATS from x user, or on appear
    //@Published var chats = Conversation.sampleChat
    @Published var chats = [Conversation]()
    @Published var msgs = [Message]()
    @Published var chatsRetrieved = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    
    func startConversation(receiver: String, message: String) {
        
        var ref: DocumentReference? = nil
        if (user != nil) {
            
            ///check if cnversation already exists then skip this step with an if!!!!
            
            db.collection("conversations").whereField("users", arrayContains: [user!.displayName, receiver])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if querySnapshot!.documents.count == 0 {
                            //no documents available, adddocument
                            //create main collection conversations
                            ref = self.db.collection("conversations").addDocument(data: ["users" : [self.user!.displayName, receiver], "createdTime" : Timestamp()]) { err in
                                if let err = err {
                                    print("error writing doc")
                                } else {
                                    print("success writing conversation/chat")
                                }
                            }
                            
                            //write the message in the subcollection
                            self.db.collection("conversations").document(ref!.documentID).collection("messages").addDocument(data: [
                                "created_by" : self.user!.displayName ?? "",
                                "msg": message,
                                "date": Date()
                            ]){ errormsg in
                                if let error = errormsg {
                                    print("error writing message")
                                } else {
                                    print("success writing message")
                                }
                            }
                        } else {
                            //print document and set Data with merge
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                //hopefiully it'ss just one doc
                                self.db.collection("conversations").document(document.documentID).setData( ["users" : [self.user!.displayName, receiver]], merge: true) { err in
                                    if let err = err {
                                        print("Error writing conversation: \(err)")
                                    } else {
                                        print("conversation successfully created")
                                        
                                        
                                        //write the message in the subcollection
                                        self.db.collection("conversations").document(ref!.documentID).collection("messages").addDocument(data: [
                                            "created_by" : self.user!.displayName ?? "",
                                            "msg": message,
                                            "date": Date()
                                        ]){ errormsg in
                                            if let error = errormsg {
                                                print("error writing message")
                                            } else {
                                                print("success writing message")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                }
            
            
        }
        
        
        
    }
    
    func sendMessageChat(_ text: String, in chat: Conversation, chatid: String) ->Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(createdBy: user!.displayName, msg: text, date: Timestamp())
            //chats[index].messages.append(message)
            //chats[index].messages.append([user!.displayName])
            
            //call firebase add message into messages subcollection
            let ref = db.collection("conversations").document(chat.id!).collection("messages")
            //ref.setData(["gender" : user.gender], merge: true)
            ref.addDocument(data: ["created_by" : user!.displayName, "msg" : text, "date" : Date()]){ errormsg in
                if let error = errormsg {
                    print("error writing message")
                } else {
                    print("success writing message")
                }
            }
            
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
        //var conversations = [Conversation]() //empty array of conversations
        
        var conversations = [Conversation]()
        //let currentUser = UserService.shared.user
        if (user != nil) {
            db.collection("conversations").whereField("users", arrayContains: user!.displayName)
                .order(by: "createdTime")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("no conversations found")
                        return
                    }
                    var index = 0
                    //cycle through all conversations to fetch messages and other fields
                    for conversationDoc in querySnapshot!.documents {
                        //query messages
                        var conver = Conversation() //empty converaation to host the mapping
                        var mensajesTotal = [Message]() //empty array of messages
                        
                        //map all fields to conversation
                        conver.id = conversationDoc.documentID //conversation id
                        conver.users = conversationDoc["users"] as? [String] ?? [""]
                        //conver.messages = mensajesTotal
                        
                        self.chats.append(conver)
                        //conversations.append(conver)//append the mapped conversation to viewModel
                        //map all the other fields
                        self.addMessagesToConv(conversation: self.chats[index], index: index)
                        index += 1
                    }//end of conversations for loop
                    
                    
                    //                    DispatchQueue.main.async {
                    //                        self.chats = conversations
                    //                    }
                    
                    //MARK: - MAPPING CONVERSATIONS
                    //                    self.chats = documents.map {(queryDocumentSnapshot) -> Conversation in
                    //                        //same as below but simpler, shorter
                    //                        //return try? queryDocumentSnapshot.data(as: Conversations.self)
                    //                        var mensajes = [Message]()
                    //                        var index = 0
                    //
                    //                        let data = queryDocumentSnapshot.data()
                    //                        let docId = queryDocumentSnapshot.documentID
                    //                        let users = data["users"] as? [String] ?? [""]
                    //                        //let mess = data["messages"] as? [Message] ?? []
                    //                        let unreadmsg = data["hasUnreadMessage"] as? Bool ?? false
                    //
                    //                        print("Conversation: \(docId)")
                    //
                    //                        print("finished one cycle of conversation")
                    //                        //return Conversation(id: docId, users: users, messages: mensajes, hasUnreadMessage: unreadmsg)
                    //                        return Conversation(id: docId, users: users, messages: [], hasUnreadMessage: unreadmsg)
                } //end of snapshot listener
            
        }
        
        
        //search for chats, hinge doesn't have it
        //        return sortedChats.filter { $0.person.name.lowercased().contains(query.lowercased()) }
    }
    
    
    func addMessagesToConv(conversation: Conversation, index: Int) {
        var mensajesTotal = [Message]()
        
        let ref = self.db.collection("conversations").document(conversation.id!).collection("messages")
            .order(by: "date")
            .addSnapshotListener { querySnapshotmsg, error in
            
            if error == nil {
                //loop throug the messages/docs
                for msgDoc in querySnapshotmsg!.documents {
                    var m = Message() //emtpy struc message
                    m.createdBy = msgDoc["created_by"] as? String ?? ""
                    m.date = msgDoc["date"] as? Timestamp ?? Timestamp()
                    m.msg = msgDoc["msg"] as? String ?? ""
                    m.id = msgDoc.documentID //firebase auto id
                    
                    mensajesTotal.append(m) //append this message to the total of messages
                    self.chats[index].messages.removeAll()
                    self.chats[index].messages = mensajesTotal
                }
            } else {
                print("error: \(error!.localizedDescription)")
            }
        }
    }
    
//    func getMessages(chatId: String) {
//
//        //let currentUser = UserService.shared.user
//        if (user != nil) {
//            db.collection("conversations").document(chatId).collection("messages").getDocuments(){ (querySnapshot, err) in
//
//                guard let documents = querySnapshot?.documents else {
//                    print("no conversations found")
//                    return
//                }
//
//
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//
//                //map docs to conversation messages
//                self.msgs = [Message]()
//                self.msgs = documents.map {(queryDocumentSnapshot) -> Message in
//
//                    let data = queryDocumentSnapshot.data()
//                    let docId = queryDocumentSnapshot.documentID
//                    let createdby = data["created_by"] as? String ?? ""
//                    let msg = data["msg"] as? String ?? ""
//                    let date = data["date"] as? Timestamp ?? Timestamp()
//                    let unreadmsg = data["hasUnreadMessage"] as? Bool ?? false
//
//                    //print("messages: \(msgs)")
//
//                    return Message(createdBy: createdby, msg: msg, date: date, id: docId)
//
//                }
//            }
//        }
//    }
    
    
    /*func getSectionMessages(for chat: Conversation) -> [[Message]] {
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
     }*/
}
