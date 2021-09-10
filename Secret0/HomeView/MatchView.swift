//
//  MatchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI

struct MatchView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var index : Int
    @State var image1: String = ""
    @State var goWhenTrue: Bool = false
    
    var body: some View {
        
        if model.usersLoaded == nil {
            ProgressView()
        } else {
            
            if model.matches.count == 0 {
                Text("No available matches. matches.count == 0")
            } else {
                //view with matches
                VStack {
                    //top bar
                    HStack {
                        Text(model.matches[index].name)
                            .frame(alignment: .leading)
                            .font(.title)
                        
                        Text("gender: \(model.matches[index].gender)")
                        Text("wants: \(model.matches[index].datingPreferences)")
                        
                        Button(action: {
                            //action to block or report user
                        }, label: {
                            Image(systemName: "ellx ipsis")
                        })
                    }
                    
                    //scroll MAIN view
                    ScrollView {
                        
                        //first block
                        VStack {
                            Group {
                                
                                //IOS15 AsyncImage(url: URL(string: "https://your_image_url_address"))
                                if model.matches[index].imageUrl1 == "" {
                                    Image(systemName: "person")
                                        .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    
                                    RemoteImage(url: model.matches[index].imageUrl1!)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200)
                                }
                                
//                                Image(uiImage: uiImage ?? UIImage())
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 300, height: 300, alignment: .center)
//                                    .clipped()
                                
                                //Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("What would you do if you only have 1 day left to live?")
                                Text(model.matches[index].Q1day2live ?? "")
                            }
//                            .onAppear() {
//                                model.images = [UIImage()] //make it an empty array first
//                                model.loadImage(for: model.matches[index].imageUrl1 ?? "")
//                            }
                            .padding()
                            
                            Group {
                                //CustomImageView(urlString: model.matches[index].imageUrl2 ?? "")
                                if model.matches[index].imageUrl2 == "" {
                                    Image(systemName: "person")
                                        .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    
                                    RemoteImage(url: model.matches[index].imageUrl2!)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200)
                                }
                                Text(model.matches[index].QlotteryWin ?? "")
                            }.padding()
                            
                            
                            Group {
                                VStack {
                                    HStack {
                                        Group {
                                            Image(systemName: "sun.min")
                                            Text("Age")
                                        }.padding(.trailing)
                                        
                                        Group {
                                            Image(systemName: "ruler")
                                            Text(String(model.matches[index].height) ?? "")
                                        }.padding(.trailing)
                                        
                                        Group {
                                            Image(systemName: "mappin.and.ellipse")
                                            Text("Location")
                                        }.padding(.trailing)
                                    }
                                    
                                    Text(model.matches[index].QmoneynotanIssue)
                                    
                                }
                            }
                            
                            Group {
                                //CustomImageView(urlString: model.matches[index].imageUrl3 ?? "")
                                if model.matches[index].imageUrl3 == "" {
                                    Image(systemName: "person")
                                        .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    
                                    RemoteImage(url: model.matches[index].imageUrl3!)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200)
                                }
                                Text(model.matches[index].bucketList)
                            }.padding()
                            
                            Group {
//                                CustomImageView(urlString: model.matches[index].imageUrl4 ?? "")
                                if model.matches[index].imageUrl4 == "" {
                                    Image(systemName: "person")
                                        .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    
                                    RemoteImage(url: model.matches[index].imageUrl4!)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200)
                                }
                                Text(model.matches[index].jokes)
                            }.padding()
                            
                            Button {
                                if self.index == model.matches.count-1 {
                                    //go back to first match
                                    self.index = 0
                                } else {
                                    self.index += 1
                                }
                            } label: {
                                Text("Next")
                            }.padding(.bottom)

                            //DISLIKE OR NEXT
    //                        NavigationLink(destination: MatchView(index: index + 1), isActive: $goWhenTrue) {
    //
    //                            Button {
    //                                goWhenTrue = true
    //                            } label: {
    //                                Text("Next")
    //                            }
    //                            .padding()
    //                            .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
    //                            .frame(width: 100)
    //                        }
                        }
                        
                        
                        
                    }//scroll view
                }
            }
            

        
        
        
    }
}
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(index: 0)
    }
}
