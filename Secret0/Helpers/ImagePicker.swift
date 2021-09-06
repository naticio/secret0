//
//  ImagePicker.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/4/21.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject var imageController: ImageController
    
    //to dismiss image picker selection...interesting is in the view model
    @Binding var showImagePicker: Bool
    
    var configuration: PHPickerConfiguration
    
    init(imageController: ImageController, showImagePicker: Binding<Bool>) {
        configuration = PHPickerConfiguration()
        //I can change this to multiple to sleect more images
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        self.imageController = imageController
        //this is related to the binding var to dismiss sheet when pic is selected...what is the _?
        self._showImagePicker = showImagePicker
    }
    
    //methords to access ImagePicker using UIKIT UIViewcontrollerrepresentable
    //This method is used for creating the UIViewController we want to present
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    //This method updates the UIViewController to the latest configuration every time it gets called
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //empty on purpose
    }
    
    //This method initializes a Coordinator that serves as a kind of a servant for handling delegate and data source patterns and user inputs. We will talk about this in more detail later.
    func makeCoordinator() -> Coordinator {
        //calling the class below
        Coordinator(self)
    }
    
}

//subclass contains the necessary function our phpicker needs to retrieve the selected photo
class Coordinator: PHPickerViewControllerDelegate {
    
    private let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.imageController.unprocessedImage = image
                    }
                }
            }
        }
        //to dismiss the sheet
        parent.showImagePicker = false
    }
}


