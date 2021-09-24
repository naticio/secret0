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
    
    @State var uploadPic: Bool = false
    @State var picNumber: Int = 0
    //@State var selectedImages: [UIImage] = []
    @State var goWhenTrue: Bool = false
    
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
                                .resizable()
                                .frame(height: 200)
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
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
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
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
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
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
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
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
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
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
                                .padding()
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width:200, height: 200)
                                    .border(Color.gray)
                                Image(systemName: "plus")
                            }
                        }
                        
                    })
                    .disabled(imageController.image5 == nil)
                    
                }

                
                /*
                //Pixlab testing button
                Button(action: {
                    //uploadImage(image: imageController.image1!)
                    requestNativeImageUpload(image: imageController.image1!)
                }, label: {
                    Text("Pixlab call")
                }) */

                
                //UPLOAD IMAGE TO FIREBASE
                NavigationLink(
                    destination: HomeView()
                        .navigationBarHidden(true)
                        .onAppear(perform: {
                            //mandalo con informacion papaw!
                            model.getMatches()
                        }),
                    isActive: $goWhenTrue,
                    label: {
                        Button(action: {
                            
                            //make face detect call but using url for image
                            
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
                            
                        }, label: {
                            Text("Next")
                                .accentColor(.red)
                                .font(.title)
                        })
                    })
                    .padding()
            } //vstack closure
            .navigationBarHidden(true)
            
            Spacer()
        }

        .sheet(isPresented: $uploadPic, content: {
            PictureYourself(uploadPic: $uploadPic, picNumber: $picNumber)
        })
        .navigationTitle("Upload some photos")
        
        
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
                    
                    ///SAVE IMAGE URL AS REFERENCE IN USER COLLECTION
                    let db = Firestore.firestore()
                    
                    //ref = path in the users collection, doc is the user id document, create a sub collection photos with the document id
                    //let ref = db.collection("users").document(userDocument.uid).collection("photos").document(documentID)
                    let FirestoreRef = db.collection("users").document(userDocument.uid)
                    
                    //download URL of the pic just posted
                    storageRef.downloadURL { url, error in
                        if error == nil {
                            //save into firestore db the url of the images just uploaded
                            FirestoreRef.setData(["photo\(picNumber)": url!.absoluteString], merge: true)
                            
                            print("SUCCESS: image original uploaded to firebase")
                            print(url!.absoluteString)
                            //if hideIdentity toggle  = true then
                            
                            //SAVE MOGRIFIED IMAGE INTO FIREBASE COLLECTION as url reference
                            switch picNumber {
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


//MARK: - ANOTHER TRY PIXLAB -stackoverflow
func requestNativeImageUpload(image: UIImage) {

    let url = URL(string: "https://api.pixlab.io/facedetect")
    let boundary = "Boundary-\(NSUUID().uuidString)"
    var request = URLRequest(url: url!)

    let parameters = ["key" : "538f491a89c9026c28be8583aaf7219c"]

    guard let mediaImage = Media(withImage: image, forKey: "file") else { return }

    request.httpMethod = "POST"

    request.allHTTPHeaderFields = [
                "X-User-Agent": "ios",
                "Accept-Language": "en",
                "Accept": "application/json",
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "ApiKey": "538f491a89c9026c28be8583aaf7219c"
            ]

    let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
    request.httpBody = dataBody

    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let response = response {
            print(response)
        }

        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }
        }.resume()
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


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.1) else { return nil }
        self.data = data
    }
}

struct PictureUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        PictureUploaderView()
            .environmentObject(ContentModel())
            .environmentObject(ImageController())
    }
}
