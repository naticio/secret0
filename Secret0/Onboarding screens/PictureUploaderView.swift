//
//  PictureUploaderView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/5/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth
import Firebase

struct PictureUploaderView: View {
    //we're observing image controller
    @EnvironmentObject var imageController: ImageController
    
    @State var uploadPic: Bool = false
    @State var picNumber: Int = 0
    
    var body: some View {
        NavigationView{
            Spacer()
            VStack {
                HStack {
                    //image1
                    Button(action: {
                        picNumber = 1
                        uploadPic.toggle()
                        
                    }, label: {
                        
                        if imageController.image1 != nil {
                            Image(uiImage: imageController.image1!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    
                    //image2
                    Button(action: {
                        picNumber = 2
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image2 != nil {
                            Image(uiImage: imageController.image2!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image1 == nil)
                    
                    //image3
                    Button(action: {
                        picNumber = 3
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image3 != nil {
                            Image(uiImage: imageController.image3!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image2 == nil)
                    
                }
                
                //2nd row
                HStack {
                    //image4
                    Button(action: {
                        picNumber = 4
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image4 != nil {
                            Image(uiImage: imageController.image4!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image3 == nil)
                    
                    //image5
                    Button(action: {
                        picNumber = 5
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image5 != nil {
                            Image(uiImage: imageController.image5!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image4 == nil)
                    
                    //image6
                    Button(action: {
                        picNumber = 6
                        uploadPic.toggle()
                    }, label: {
                        if imageController.image6 != nil {
                            Image(uiImage: imageController.image6!.compressed() ?? UIImage())
                                .frame(width:100, height: 100)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:100, height: 100)
                                    .border(Color.black)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image5 == nil)
                    
                }
                
                //UPLOAD IMAGE TO FIREBASE
                Button(action: {
                    if imageController.image1 != nil {
                    uploadImage(image: imageController.image1!)
                    }
                }, label: {
                    Text("Upload image1 to Firebase")
                })
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $uploadPic, content: {
            PictureYourself(uploadPic: $uploadPic, picNumber: $picNumber)
        })
        .navigationTitle("Upload some photos")
        
        
    }
}

//UPLOAD IMAGE INTO FIREBASE STORAGE
func uploadImage(image:UIImage){
    if let imageData = image.jpegData(compressionQuality: 0.1){
        let storage = Storage.storage()
        
        let userDocument = Auth.auth().currentUser! //get document id for current user
        //db.collection("users").document(loggedInUser.uid)
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create unique filename for the picture, so it can have an id inside the bucket/folder
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
                        FirestoreRef.setData(["photo1": url!.absoluteString], merge: true)
                    }
                    
                }
            
                

                
                //what about the image itself? or URL?
            }
        }
    } else {
        print("coldn't unwrap/case image to data")
    }
}

struct PictureUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        PictureUploaderView()
    }
}
