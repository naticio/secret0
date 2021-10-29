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
    @EnvironmentObject var model: ContentModel
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    @State var uploadPic: Bool = false
    @State var picNumber: Int = 0
    //@State var selectedImages: [UIImage] = []
    @State var goWhenTrue: Bool = false
    
    var body: some View {
        
        NavigationView{

            VStack {
                //Spacer()
                Text("Upload some photos")
                    .font(.title)
                    .bold()
                //row 1
                HStack {
                    //image1
                    Button(action: {
                        picNumber = 1
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image1 != nil {
                            Image(uiImage: imageController.image1!.compressed() ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
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
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image1 == nil)
                    
                }
                
                //2nd row
                HStack {
                    //image3
                    Button(action: {
                        picNumber = 3
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image3 != nil {
                            Image(uiImage: imageController.image3!.compressed() ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image2 == nil)
                    
                    //image4
                    Button(action: {
                        picNumber = 4
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image4 != nil {
                            Image(uiImage: imageController.image4!.compressed() ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image3 == nil)
                }
                
                //3rd row
                HStack {
                    
                    //image5
                    Button(action: {
                        picNumber = 5
                        uploadPic.toggle()
                        
                    }, label: {
                        if imageController.image5 != nil {
                            Image(uiImage: imageController.image5!.compressed() ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
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
                                .resizable()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                        } else {
                            ZStack {
//                                Rectangle()
//                                    .fill(Color.white)
//                                    .frame(width:200, height: 200)
//                                    .border(Color.gray)
                                Rectangle()
                                    .fill(Color.white)
                                    //.frame(width:200, height: 200)
                                    //.border(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .aspectRatio(CGSize(width: 200, height:200), contentMode: .fit)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image5 == nil)
                    
                }
                
                if imageController.image1 == nil {
                    Text("Updload one picture at least")
                        .padding(.top)
                }
                
                //UPLOAD IMAGE TO FIREBASE
                NavigationLink(
                    destination: LaunchLogicView()
                        .navigationBarBackButtonHidden(true)
                        .onAppear(perform: {
                            //mandalo con informacion papaw!
                            
                            //model.getMatches()
                            if model.usersLoaded == false {
                                model.getMatchesNearMeDispatch(radius: 50)
                                //model.getUserData()
                            }

                        }),
                    isActive: $goWhenTrue,
                    label: {
                        Button(action: {
                            
                            
                            //I need to send all images at once as array I believe
                            if imageController.image1 != nil {
                                uploadImageFirebase(image: imageController.image1!, picNumber: 1)
                            }
                            if imageController.image2 != nil {
                                uploadImageFirebase(image: imageController.image2!, picNumber: 2)
                            }
                            if imageController.image3 != nil {
                                uploadImageFirebase(image: imageController.image3!, picNumber: 3)
                            }
                            if imageController.image4 != nil {
                                uploadImageFirebase(image: imageController.image4!, picNumber: 4)
                            }
                            if imageController.image5 != nil {
                                uploadImageFirebase(image: imageController.image5!, picNumber: 5)
                            }
                            if imageController.image6 != nil {
                                uploadImageFirebase(image: imageController.image6!, picNumber: 6)
                            }
//
                            //model.checkLogin()
                            goWhenTrue = true
                            isOnboarding = false
                            
                        }, label: {
                            Text("Next")
                                .accentColor(.red)
                                .font(.title)
                        })
                    })
                    .padding()
            } //vstack closure
            .navigationBarHidden(true)
            //.navigationTitle("Upload some photos")
            
            Spacer()
        }
        
        //MARK: - SHOW THE picture yourself view
        .sheet(isPresented: $uploadPic, content: {
            PictureYourself(uploadPic: $uploadPic, picNumber: $picNumber)
        })
        .navigationBarHidden(true)
        
    }
    
    //UPLOAD IMAGE INTO FIREBASE STORAGE
    func uploadImageFirebase(image:UIImage, picNumber: Int){
        
        if let imageData = image.jpegData(compressionQuality: 0.1){
            
            //let userDocument = Auth.auth().currentUser! //get document id for current user
            let storage = Storage.storage()
            let user = UserService.shared.user
            
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            
            //create unique file name for the picture, so it can have an id inside the bucket/folder
            let documentID = UUID().uuidString //Assign unique identifier
            
            //SAVE IMAGE TO STORAGE
            ///reference to storage root, bucket is userDocument id, then files are photo uploaded with a unique id
            let storageRef = storage.reference().child(user.name).child(user.name + documentID)
            let uploadTask = storageRef.putData(imageData, metadata: uploadMetaData){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                    
                    ///SAVE IMAGE URL AS REFERENCE IN USER COLLECTION
                    let db = Firestore.firestore()
                    
                    //ref = path in the users collection, doc is the user id document, create a sub collection photos with the document id
                    //let ref = db.collection("users").document(userDocument.uid).collection("photos").document(documentID)
                    let FirestoreRef = db.collection("users").document(user.name)
                    
                    //download URL of the pic just posted
                    storageRef.downloadURL { url, error in
                        if error == nil {
                            //save into firestore db the url of the images just uploaded
                            FirestoreRef.setData(["photo\(picNumber)": url!.absoluteString], merge: true)
                            
                         
                            
                            print("SUCCESS: image original uploaded to firebase")
                            print(url!.absoluteString)
                            //so I can save images posted into User singleton
                            
                            switch picNumber {
                            case 1:
                                UserService.shared.user.imageUrl1 = url!.absoluteString
                            case 2:
                                UserService.shared.user.imageUrl2 = url!.absoluteString
                            case 3:
                                UserService.shared.user.imageUrl3 = url!.absoluteString
                            case 4:
                                UserService.shared.user.imageUrl4 = url!.absoluteString
                            case 5:
                                UserService.shared.user.imageUrl5 = url!.absoluteString
                            case 6:
                                UserService.shared.user.imageUrl6 = url!.absoluteString
                                
                            default:
                                print("No pics")
                            }
                            //UserService.shared.user.imageUrl1 = url!.absoluteString
                            //if hideIdentity toggle  = true then
                            
                            //SAVE BLURRED IMAGE INTO FIREBASE COLLECTION as url reference
                            switch picNumber {
                            case 1:
                                if imageController.faceBlurredImage1 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage1], merge: true)
                                }
                            case 2:
                                if imageController.faceBlurredImage2 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage2], merge: true)
                                }
                            case 3:
                                if imageController.faceBlurredImage3 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage3], merge: true)
                                }
                            case 4:
                                if imageController.faceBlurredImage4 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage4], merge: true)
                                }
                            case 5:
                                if imageController.faceBlurredImage5 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage5], merge: true)
                                }
                            case 6:
                                if imageController.faceBlurredImage6 != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.faceBlurredImage6], merge: true)
                                }
                            default:
                                print("No hidden images this time my friend")
                            }
                            
                            /*switch picNumber {
                            case 1:
                                if imageController.image1Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image1Mogrify], merge: true)
                                }
                            case 2:
                                if imageController.image2Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image2Mogrify], merge: true)
                                }
                            case 3:
                                if imageController.image3Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image3Mogrify], merge: true)
                                }
                            case 4:
                                if imageController.image4Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image4Mogrify], merge: true)
                                }
                            case 5:
                                if imageController.image5Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image5Mogrify], merge: true)
                                }
                            case 6:
                                if imageController.image6Mogrify != nil {
                                    FirestoreRef.setData(["photoHidden\(picNumber)": imageController.image6Mogrify], merge: true)
                                }
                            default:
                                print("No hidden images this time my friend")
                            }*/
                            
                        }
                        
                    }
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
        }
        
    }
    

    
}

func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {

    let lineBreak = "\r\n"
    var body = Data()

    if let parameters = params {
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
    }

    if let media = media {
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
    }

    body.append("--\(boundary)--\(lineBreak)")

    return body
}


struct PictureUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        PictureUploaderView()
            .environmentObject(ContentModel())
            .environmentObject(ImageController())
    }
}
