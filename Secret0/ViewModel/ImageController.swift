//
//  ImageController.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/4/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class ImageController: ObservableObject {
    
    @Published var unprocessedImage: UIImage? {
        didSet {
            displayedImage = unprocessedImage
        }
    }
    
    @Published var displayedImage: UIImage? //optional might be nil
    
    @Published var image1: UIImage?
    @Published var image2: UIImage?
    @Published var image3: UIImage?
    @Published var image4: UIImage?
    @Published var image5: UIImage?
    @Published var image6: UIImage?
    
    //urls from firebase to use for pixlab facedetec and mogrify
    @Published var image1url: String?
    @Published var image2url: String?
    @Published var image3url: String?
    @Published var image4url: String?
    @Published var image5url: String?
    @Published var image6url: String?
    
    //mogrify images
    @Published var image1Mogrify: String?
    @Published var image2Mogrify: String?
    @Published var image3Mogrify: String?
    @Published var image4Mogrify: String?
    @Published var image5Mogrify: String?
    @Published var image6Mogrify: String?
    
    

    func generateFilteredImage(inputImage: UIImage?, filter: FilterType) -> UIImage? {
        let context = CIContext(options: nil)
        
        //make sure input image is not empty, and oconvert it to CIImage o coreIMage framework can process it
        guard let imageToEdit = CIImage(image: inputImage!) else {
            return nil
        }
        
        //to select the filter to process the image
        switch filter {
        case .Original:
            return unprocessedImage
            
        case .Sepia:
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(imageToEdit, forKey: "inputImage")
            
            if let output = filter?.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
            
        case .Mono:
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter?.setValue(imageToEdit, forKey: "inputImage")
            
            if let output = filter?.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
        case .Vibrance:
            let filter = CIFilter(name: "CIVibrance")
            filter?.setValue(imageToEdit, forKey: "inputImage")
            filter?.setValue(20, forKey: "inputAmount")
            
            if let output = filter?.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
        }
        //in case something goes to shit or error then return the same input image
        return inputImage
    }
    
   
}
