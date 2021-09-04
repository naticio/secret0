//
//  ImageController.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/4/21.
//

import SwiftUI

class ImageController: ObservableObject {
    @Published var unprocessedImage: UIImage? {
        didSet {
                    displayedImage = unprocessedImage
                }
    }
    
    var displayedImage: UIImage? //optional might be nil
}
