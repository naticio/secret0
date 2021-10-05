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
                            .frame(width: geometry.size.width, height: geometry.size.height*0.5)
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
                                    
                                    storeImage(image: imageController.image1!, picNum: picNumber)
                                }
                                if picNumber == 2 {
                                    imageController.image2 = imageController.displayedImage
                                    
                                    storeImage(image: imageController.image2!, picNum: picNumber)
                                    
                                }
                                if picNumber == 3 {
                                    imageController.image3 = imageController.displayedImage
                                    
                                    storeImage(image: imageController.image3!, picNum: picNumber)
                                    
                                }
                                if picNumber == 4 {
                                    imageController.image4 = imageController.displayedImage
                                    
                                    storeImage(image: imageController.image4!, picNum: picNumber)
                                    
                                }
                                if picNumber == 5 {
                                    imageController.image5 = imageController.displayedImage
                                    
                                    storeImage(image: imageController.image5!, picNum: picNumber)
                                    
                                }
                                if picNumber == 6 {
                                    imageController.image6 = imageController.displayedImage
                                    
                                    storeImage(image: imageController.image6!, picNum: picNumber)
                                }
                            } else {
                                //if false just save original image in memory to save it later firebase
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
            .navigationBarHidden(true)
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
    
    /*func BrazilianUpload(image:UIImage, picNum: Int) {
        let urlPath = "https://api.pixlab.io/store"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mimeType = "image/jpg"
        
        let params: [String : String]? = ["key" :Constants.pixlabAPIkey]
        
        let body = NSMutableData()
        let boundaryPrefix = " — \(boundary)\r\n"
        
        for (key, value) in params! {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        let imageData = image.jpegData(compressionQuality: 0.1)
        var filename = "image1.png"
        
        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageData!)
        body.append("\r\n")
        body.append(" — ".appending(boundary.appending(" — ")))
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
        //do whatever want with the response here
            
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
                    
                    facedetectGET(uploadedUrl: result.ssl_link, picNum: picNum)
                    
                    
                } catch {
                    print(error)
                }
            }
        }
        }.resume()
    }*/
    
    //MARK: - store Image in pixlab for facedetect and mogrify
    func storeImage(image: UIImage, picNum: Int) {
            
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
                        
                        facedetectGET(uploadedUrl: result.ssl_link, picNum: picNum)
                        
                        
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    
    /*func uploadImageToServer(image: UIImage, picNum: Int) {
        let parameters = ["key" : Constants.pixlabAPIkey,
                          "name": "MyTestFile123321",
                          "id": "12345"]
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        guard let url = URL(string: "https://api.pixlab.io/store") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //create boundary
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
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
    }*/
    
    /*func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {

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
    }*/
    
    //MARK: - PIXLAB facedetect
    func facedetectGET(uploadedUrl: String, picNum: Int) {
        
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
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options:[])
                            print("Facedetect response")
                            print(json)
                            
                            //decode the json to an array of faces
                            let cord = try! JSONDecoder().decode(Cord.self, from: data!)
                            print(cord.faces)
                            
                            let cordData = try! JSONEncoder().encode(cord.faces)
                            let coordinates = try JSONSerialization.jsonObject(with: cordData, options:[])
                            print(coordinates)
                            
                            //mogrify call
                            mogrify(uploadedUrl: uploadedUrl, cord: coordinates, picNum: picNum)
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
    func mogrify(uploadedUrl: String, cord: Any, picNum: Int) {
        
        let mogrifyurl = URL(string: "https://api.pixlab.io/mogrify")!
        
        //let param: [Face] = result.faces
        let param: [String: Any] = ["img": uploadedUrl, "key": Constants.pixlabAPIkey, "cord": cord]
        
        var request = URLRequest(url: mogrifyurl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.pixlabAPIkey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options:[])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[])
                print("MOGRIFY response")
                print(json)
                
                let mogrifyRes = try! JSONDecoder().decode(mogrifyResponse.self, from: data!)
                //var secureLink = result.sslLink
                
                //save image mogrified in pixlab into memory in image controller
                
                DispatchQueue.main.async {
                    switch picNum {
                    case 1:
                        imageController.image1Mogrify = mogrifyRes.ssl_link
                    case 2:
                        imageController.image2Mogrify = mogrifyRes.ssl_link
                    case 3:
                        imageController.image3Mogrify = mogrifyRes.ssl_link
                    case 4:
                        imageController.image4Mogrify = mogrifyRes.ssl_link
                    case 5:
                        imageController.image5Mogrify = mogrifyRes.ssl_link
                    case 6:
                        imageController.image6Mogrify = mogrifyRes.ssl_link
                        
                    default:
                        print("No picNum provided")
                    }
                }
            } catch {
                print("error")
            }
        }.resume()
    }
    
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
        PictureYourself(uploadPic: $picUpload, picNumber: $numberPic)
            .environmentObject(ImageController())
    }
}
