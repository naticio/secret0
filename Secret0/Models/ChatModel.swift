//
//  ChatModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation

struct Conversation: Identifiable {
    //var id: UUID { person.id }
    var id: String
    let parties: [String]
    var person1Img: String
    var person2Img: String
    var person1name: String
    var person2name: String
    var messages: [Message]
    var hasUnreadMessage = false
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.text = text
        self.type = type
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

//struct Person: Identifiable {
//    let id = UUID()
//    let name: String
//    let imgString: String
//}
