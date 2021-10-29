//
//  Models.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestoreSwift

class User {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var birthdate: Date = Date()
    var location: CLLocation?
    var latitude: Double?
    var longitude: Double?
    var gender: String = ""
    var sexuality: String = ""
    var datingPreferences: String = ""
    var height: Int = 0
    var Q1day2live: String = ""
    var QlotteryWin: String = ""
    var QmoneynotanIssue: String = ""
    var bucketList: String = ""
    var jokes: String = ""
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var imageUrl4: String?
    var imageUrl5: String?
    var imageUrl6: String?
    var city: String?
    var blocked_users: [String]?
    
}

class Matches: Decodable, Identifiable, ObservableObject {
    
    @Published var imageData: Data?
    
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var birthdate: Date = Date()
    var location: Location?
    var latitude: Double?
    var longitude: Double?
    var gender: String = ""
    var sexuality: String = ""
    var datingPreferences: String = ""
    var height: Int = 0
    var Q1day2live: String = ""
    var QlotteryWin: String = ""
    var QmoneynotanIssue: String = ""
    var bucketList: String = ""
    var jokes: String = ""
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var imageUrl4: String?
    var imageUrl5: String?
    var imageUrl6: String?
    var conversations : [String]?
    var city: String?
    var blocked_users: [String]?

    enum CodingKeys: String, CodingKey {
        
        case imageUrl1 = "image_url1"
        case imageUrl2 = "image_url2"
        case imageUrl3 = "image_url3"
        case imageUrl4 = "image_url4"
        case imageUrl5 = "image_url5"
        case imageUrl6 = "image_url6"
    }
}

struct Location: Decodable {
    var address: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case displayAddress = "display_address"
        
        case address
        case city
        case country
        case state
        
    }
}

struct onboardingScreen: Identifiable {
    var id = UUID()
    var title: String
    var disclaimer: String
    var image: String
}
