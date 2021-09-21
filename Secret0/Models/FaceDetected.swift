//
//  FaceDetected.swift
//  Pods
//
//  Created by Nat-Serrano on 9/20/21.
//

import Foundation

struct FaceDetected: Decodable {
    
    var faces = [Face]()
    var count : Int?
    //var error : String?
}

struct Face: Codable {
    //var center = Coordinate()
//    var bottom : Int?
//    var face_id: Int?
//    var height : Int?
//    var left : Int?
//    var right : Int?
//    var top : Int?
//    var width : Int?
    
    var faces: [String:Int?]
}

struct storedImgJson: Decodable {
    
    var id : String
    var link : String
    var ssl_link : String
    var status : Int
}




