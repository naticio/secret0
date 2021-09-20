//
//  PictureYourself.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/4/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

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
                            .frame(width: geometry.size.width, height: geometry.size.height*0.7)
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
                                

                                uploadImageFirebase(image: imageController.image1!, picNumber: 1)
                            }
                            if picNumber == 2 {
                                imageController.image2 = imageController.displayedImage
                                
                                uploadImageFirebase(image: imageController.image2!, picNumber: 2)
                            }
                            if picNumber == 3 {
                                imageController.image3 = imageController.displayedImage
                                
                                uploadImageFirebase(image: imageController.image3!, picNumber: 3)
                            }
                            if picNumber == 4 {
                                imageController.image4 = imageController.displayedImage
                                
                                uploadImageFirebase(image: imageController.image4!, picNumber: 4)
                            }
                            if picNumber == 5 {
                                imageController.image5 = imageController.displayedImage
                                
                                uploadImageFirebase(image: imageController.image5!, picNumber: 5)
                            }
                            if picNumber == 6 {
                                imageController.image6 = imageController.displayedImage
                                
                                uploadImageFirebase(image: imageController.image6!, picNumber: 6)
                            }
                            
                            uploadPic = false
                            
                        } label: {
                            Text("Done Editing")
                        }
                        //.disabled(index == nil)
                        .padding()
                        .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                        //.frame(width: 100)
                        
                    } else {
                        //no image yet in imageController.displayedIMage so we ask user to upload
                        Spacer()
                        Text("Upload a photo to start editing.")
                            .frame(width: geometry.size.width, height: geometry.size.height*0.25)
                        Spacer()
                    }
                    
                }
            }
            //.navigationBarTitle("Images", displayMode: .inline)
            //button for user to tap to the gallery
//            .toolbar(content: {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    GalleryButton(showImagePicker: $showImagePicker)
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    SaveButton()
//                }
//            })
            .sheet(isPresented: $showImagePicker, content: {
                //call the helper image picker to select photos (PHPicker)
                ImagePicker(imageController: imageController, showImagePicker: $showImagePicker)
            })
            
        }
        
    }
    
    //UPLOAD IMAGE INTO FIREBASE STORAGE
    func uploadImageFirebase(image:UIImage, picNumber: Int){
        
        if let imageData = image.jpegData(compressionQuality: 0.1){
            
            let userDocument = Auth.auth().currentUser! //get document id for current user
            let storage = Storage.storage()
            
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            
            //create unique file name for the picture, so it can have an id inside the bucket/folder
            let documentID = UUID().uuidString //Assign unique identifier
            
            //SAVE IMAGE TO STORAGE
            ///reference to storage root, bucket is userDocument id, then files are photo uploaded with a unique id
            let storageRef = storage.reference().child(userDocument.uid).child(documentID)
            let uploadTask = storageRef.putData(imageData, metadata: uploadMetaData){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                    
                    //save image url into users collection as a field
                    let db = Firestore.firestore()
                    
                    //ref = path in the users collection, doc is the user id document, create a sub collection photos with the document id
                    //let ref = db.collection("users").document(userDocument.uid).collection("photos").document(documentID)
                    let FirestoreRef = db.collection("users").document(userDocument.uid)
                    
                    //download URL of the pic just posted
                    storageRef.downloadURL { url, error in
                        if error == nil {
                            //save into firestore db the url of the images just uploaded
                            FirestoreRef.setData(["photo\(picNumber)": url!.absoluteString], merge: true)
                            
                            if picNumber == 1 {
                                imageController.image1url = url!.absoluteString
                            }
                            
                            if picNumber == 2 {
                                imageController.image2url = url!.absoluteString
                            }
                            
                            if picNumber == 3 {
                                imageController.image3url = url!.absoluteString
                            }
                            
                            if picNumber == 4 {
                                imageController.image4url = url!.absoluteString
                            }
                            
                            if picNumber == 5 {
                                imageController.image5url = url!.absoluteString
                            }
                            
                            if picNumber == 6 {
                                imageController.image6url = url!.absoluteString
                            }
                        }
                        
                    }
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
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





struct PictureYourself_Previews: PreviewProvider {
    @State static var picUpload = true
    @State static var numberPic = 1
    
    static var previews: some View {
        //so we can display the preview
        PictureYourself(uploadPic: $picUpload, picNumber: $numberPic).environmentObject(ImageController())
    }
}
