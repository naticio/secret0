//
//  FaceDetected.swift
//  Pods
//
//  Created by Nat-Serrano on 9/20/21.
//

import Foundation



struct Cord: Codable {

    var faces: [Face]
    var status: Int
}

struct Face: Codable {

    var bottom : Int
    var face_id: Int
    var height : Int
    var left : Int
    var right : Int
    var top : Int
    var width : Int
}

struct mogrifyResponse: Codable {
    var id: String
    var link : String
    var ssl_link : String
    var status : Int
}



struct storedImgJson: Decodable {
    
    var id : String
    var link : String
    var ssl_link : String
    var status : Int
}




