//
//  PictureYourself.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/4/21.
//

import SwiftUI

struct PictureYourself: View {
    
    @EnvironmentObject var imageController: ImageController
    @State var showImagePicker = true
    
    @Binding var uploadPic: Bool
    @Binding var picNumber: Int
    
    //array for the filters
    let availableFilters: [FilterType] = [.Original, .Sepia, .Mono, .Vibrance]
    
    //binding to the previous view?
    init(uploadPic: Binding<Bool>, picNumber: Binding<Int>) {
        self._uploadPic = uploadPic
        self._picNumber = picNumber
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    //Image preview
                    //make sure is not nil
                    if let imageToDisplay = imageController.displayedImage, let originalImage = imageController.unprocessedImage {
                        Image(uiImage: imageToDisplay)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height*0.75)
                            .clipped()
                        
                        //image filters
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                //horizontal mini images of the preview image with filters
                                //button for the image to change filter
                                //for each to create a button thumbnail fro each filter type
                                ForEach(availableFilters, id: \.self) { filter in
                                    Button(action: {
                                        //compressed is an extension available in extensions files in helpers to compress image
                                        imageController.displayedImage = imageController.generateFilteredImage(inputImage: originalImage.compressed(), filter: filter)
                                    }, label: {
                                        ThumbnailView(width: geometry.size.width*(21/100), height: geometry.size.height*(15/100), filterName: "\(filter)", imageToDisplay: originalImage)
                                    })
                                }
                                
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height*(1/4))
                        
                        
                        //BUTTON done editing pic
                        Button {
                            
                            
                            if picNumber == 1 {
                                imageController.image1 = imageController.displayedImage
                            }
                            if picNumber == 2 {
                                imageController.image2 = imageController.displayedImage
                            }
                            if picNumber == 3 {
                                imageController.image3 = imageController.displayedImage
                            }
                            if picNumber == 4 {
                                imageController.image4 = imageController.displayedImage
                            }
                            if picNumber == 5 {
                                imageController.image5 = imageController.displayedImage
                            }
                            if picNumber == 6 {
                                imageController.image6 = imageController.displayedImage
                            }
                            
                            uploadPic = false
                            
                            
                        } label: {
                            Text("Done Editing")
                        }
                        //.disabled(index == nil)
                        .padding()
                        .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                        .frame(width: 100)
                        
                    } else {
                        //no image yet in imageController.displayedIMage so we ask user to upload
                        Spacer()
                        Text("Upload a photo to start editing.")
                            .frame(width: geometry.size.width, height: geometry.size.height*0.25)
                        Spacer()
                    }
                    
                }
            }
            .navigationBarTitle("Images", displayMode: .inline)
            //button for user to tap to the gallery
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    GalleryButton(showImagePicker: $showImagePicker)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    SaveButton()
                }
            })
            .sheet(isPresented: $showImagePicker, content: {
                //call the helper image picker to select photos (PHPicker)
                ImagePicker(imageController: imageController, showImagePicker: $showImagePicker)
            })
            
        }
        
    }
}

//preview image view
struct ThumbnailView: View {
    
    let width: CGFloat
    let height: CGFloat
    let filterName: String
    let imageToDisplay: UIImage
    
    var body: some View {
        VStack {
            Text(filterName)
                .foregroundColor(Color("LightGray"))
            Image(uiImage: imageToDisplay)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .cornerRadius(20)
                .clipped()
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}



struct GalleryButton: View {
    
    @Binding var showImagePicker: Bool
    
    var body: some View {
        Button(action: {
            showImagePicker = true
        }) {
            Image(systemName: "photo")
                .imageScale(.large)
        }
    }
}

struct SaveButton: View {
    var body: some View {
        Button(action: {
            print("Save edited photo.")
        }) {
            Image(systemName: "square.and.arrow.down")
                .imageScale(.large)
        }
    }
}

//
//struct PictureYourself_Previews: PreviewProvider {
//    static var previews: some View {
//        //so we can display the preview
//        PictureYourself(uploadPic: uploadPic, picNumber: picNumber).environmentObject(ImageController())
//    }
//}
