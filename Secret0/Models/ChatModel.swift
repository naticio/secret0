//
//  ChatModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Conversation: Decodable, Identifiable {
    //var id: UUID { person.id }
    @DocumentID var id: String? = UUID().uuidString
    var users: [String] = [""]
    var messages: [Message] = []
    var hasUnreadMessage : Bool = false
}

struct Message: Decodable, Hashable {
    var createdBy: String?
    var msg: String?
    @ServerTimestamp var date : Timestamp?
    var id : String?
}

let sampleConv = Conversation(id: "abc", users: ["lolameraz", "charly"], messages: sampleMessages)

let sampleMessages = [
    Message(createdBy: "lolameraz", msg: "mensaje test", date: Timestamp(), id: "123"),
    Message(createdBy: "charly", msg: "mensaje response", date: Timestamp(), id: "456")
]

/*struct Message: Decodable, Identifiable, Hashable {

    enum MessageType : Codable {
        case Sent, Received
    }

    var id = UUID()
    //var id : Int
    var date: Date
    var msg: String
    var type: MessageType?

    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.msg = text
        self.type = type
    }

    init(_ msg: String, type: MessageType) {
        self.init(msg, type: type, date: Date())
    }
}*/

//struct Person: Identifiable {
//    let id = UUID()
//    let name: String
//    let imgString: String
//}
