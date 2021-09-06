//
//  PictureUploaderView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/5/21.
//

import SwiftUI

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

                }
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

struct PictureUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        PictureUploaderView()
    }
}
