//
//  ChatModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/29/21.
//

import Foundation
import SwiftUI

class Conversations: Decodable, Identifiable, ObservableObject {
    //var id: UUID { person.id }
    var id: String = ""
    var users: [String] = [""]
    var messages: [Message] = []
    var hasUnreadMessage : Bool = false
}

struct Message: Decodable {

    enum MessageType {
        case Sent, Received
    }

    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType?

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
