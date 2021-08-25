//
//  Models.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import Foundation
import SwiftUI

class User {
    var name: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
}

struct onboardingScreen: Identifiable {
    var id = UUID()
    var title: String
    var disclaimer: String
    var image: String
}
