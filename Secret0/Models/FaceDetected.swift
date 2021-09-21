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

struct Face: Decodable {
    //var center = Coordinate()
    var face_id: Int?
    var left : Int?
    var top : Int?
    var width : Int?
    var height : Int?

}

struct storedImage: Decodable {
    
    var id = ""
    var link = ""
    var sslLink = ""
    var status = 0
}

