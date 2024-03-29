//
//  Extensions.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/5/21.
//

import Foundation
import UIKit
import CoreLocation
import Contacts


//compress images TO HELP with performance in the thumbnail previews! makes image smaller

extension UIImage {
    func compressed() -> UIImage? {
        var compressedImage = UIImage()
        
        if let imageData = self.pngData(){
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 200] as CFDictionary

            imageData.withUnsafeBytes { ptr in
               guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                  return
               }
               if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count){
                  let source = CGImageSourceCreateWithData(cfData, nil)!
                  let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                  compressedImage = UIImage(cgImage: imageReference)
               }
            }
        }
        
        return compressedImage
    }
}


//to format CLPLACEMARK for a better address
extension CLPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else {
            return nil
        }
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: postalAddress)
    }
}


extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
