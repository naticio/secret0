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
    
    @State var hideIdentity : Bool = true
    
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
                        
                        Toggle(isOn: $hideIdentity, label: {
                            Text("Hide my identity")
                        })
                        //BUTTON done editing pic
                        Button {
                            
                            if hideIdentity == true {
                                if picNumber == 1 {
                                    imageController.image1 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image1!, picNumber: 1, hideFace: true)
                                    storeImage(image: imageController.image1!)
                                }
                                if picNumber == 2 {
                                    imageController.image2 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image2!, picNumber: 2, hideFace: true)
                                    
                                    storeImage(image: imageController.image2!)
                                    
                                }
                                if picNumber == 3 {
                                    imageController.image3 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image3!, picNumber: 3, hideFace: true)
                                    
                                    storeImage(image: imageController.image3!)
                                    
                                }
                                if picNumber == 4 {
                                    imageController.image4 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image4!, picNumber: 4, hideFace: true)
                                    
                                    storeImage(image: imageController.image4!)
                                    
                                }
                                if picNumber == 5 {
                                    imageController.image5 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image5!, picNumber: 5, hideFace: true)
                                    
                                    storeImage(image: imageController.image5!)
                                    
                                }
                                if picNumber == 6 {
                                    imageController.image6 = imageController.displayedImage
                                    //uploadImageFirebase(image: imageController.image6!, picNumber: 6, hideFace: true)
                                    
                                    storeImage(image: imageController.image6!)
                                }
                            } else {
                                if picNumber == 1 {
                                    imageController.image1 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image1!, picNumber: 1, hideFace: false)
                                    
                                    //call facedetect inside upload image firebase
                                }
                                if picNumber == 2 {
                                    imageController.image2 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image2!, picNumber: 2, hideFace: false)
                                    
                                }
                                if picNumber == 3 {
                                    imageController.image3 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image3!, picNumber: 3, hideFace: false)
                                    
                                }
                                if picNumber == 4 {
                                    imageController.image4 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image4!, picNumber: 4, hideFace: false)
                                    //call facedetect
                                }
                                if picNumber == 5 {
                                    imageController.image5 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image5!, picNumber: 5, hideFace: false)
                                    //call facedetect, then insie
                                }
                                if picNumber == 6 {
                                    imageController.image6 = imageController.displayedImage
                                    uploadImageFirebase(image: imageController.image6!, picNumber: 6, hideFace: false)
                                }
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
    
    //MARK: - store Image in pixlab for facedetect and mogrify
    func storeImage(image: UIImage) {
        
        let url = URL(string: "https://api.pixlab.io/store")
        let boundary = "Boundary-\(NSUUID().uuidString)"
        var request = URLRequest(url: url!)
        
        let parameters = ["key" : Constants.pixlabAPIkey]
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "ApiKey": Constants.pixlabAPIkey
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
                    
                    //decode a json from data to storedImgJson
                    let result = try! JSONDecoder().decode(storedImgJson.self, from: data)
                    //var secureLink = result.sslLink
                    
                    facedetectGET(uploadedUrl: result.ssl_link)
                    
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //MARK: - PIXLAB facedetect
    func facedetectGET(uploadedUrl: String) {
        
        
        
        var urlComponents = URLComponents(string: "https://api.pixlab.io/facedetect")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "img", value: uploadedUrl),
            URLQueryItem(name: "key", value: Constants.pixlabAPIkey),
        ]
        let url = urlComponents?.url
        
        if let url = url {
            
            // Create URL Request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.pixlabAPIkey)", forHTTPHeaderField: "Authorization")
            
            // Get URLSession
            let session = URLSession.shared
            
            // Create Data Task
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                // Check that there isn't an error
                if error == nil {
                    
                    do {
                        
                        if data != nil {
                            //decode the json to an array of faces
                            let cord = try! JSONDecoder().decode(Cord.self, from: data!)
                            print(cord.faces)
                            
                            let cordData = try! JSONEncoder().encode(cord.faces)
                            let coordinates = try JSONSerialization.jsonObject(with: cordData, options: [])
                            print(coordinates)
                            
                            //mogrify call
                            mogrify(uploadedUrl: uploadedUrl, cord: coordinates)
                        }

                        
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
            // Start the Data Task
            dataTask.resume()
        }
        
    }
    
    //MOGRIFY CALL
    func mogrify(uploadedUrl: String, cord: Any) {
        
        let mogrifyurl = URL(string: "https://api.pixlab.io/mogrify")!
        
        //let param: [Face] = result.faces
        let param: [String: Any] = ["img": uploadedUrl, "key": Constants.pixlabAPIkey, "cord": cord]
        
        var request = URLRequest(url: mogrifyurl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.pixlabAPIkey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!)
                print("MOGRIFY response")
                print(json)
            } catch {
                print("error")
            }
        }.resume()
    }
    
    
    //UPLOAD IMAGE INTO FIREBASE STORAGE
    func uploadImageFirebase(image:UIImage, picNumber: Int, hideFace: Bool){
        
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
                            
                            print("SUCCESS: image uploaded to firebase")
                            print(url!.absoluteString)
                            //if hideIdentity toggle  = true then
                            if hideFace == true {
                                //face detect with url!.absoluteString
                                //facedetectGET(uploadedUrl: url!.absoluteString)
                                facedetectGET(uploadedUrl: "\(url!.absoluteString) + .jpeg")
                                
                                
                                //mogrify with url!.absoluteString
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
