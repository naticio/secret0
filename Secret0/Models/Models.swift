//
//  Models.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation
import SwiftUI
import CoreLocation

class User {
    var name: String = ""
    var birthdate: Date = Date()
    var location: CLLocation?
    var gender: String = ""
    var sexuality: String = ""
    var datingPreferences: String = ""
    var height: Int = 0
    var Q1day2live: String = ""
    var QlotteryWin: String = ""
    var QmoneynotanIssue: String = ""
    var bucketList: String = ""
    var jokes: String = ""
    
    
    
}

struct onboardingScreen: Identifiable {
    var id = UUID()
    var title: String
    var disclaimer: String
    var image: String
}
