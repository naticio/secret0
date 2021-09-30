//
//  MatchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI

struct MatchView: View {
    
    @EnvironmentObject var model: ContentModel

    
    //to hide view
    @State var viewShown = false
    @State var transitionShown = false
    
    //modal like
    @State var likeModal = false

    
    @State var index : Int
    @State var image1: String = ""
    @State var goWhenTrue: Bool = false
    
    @State private var scrollViewID = UUID()
    @State private var reader: ScrollViewProxy?
    
    var body: some View {
        
        if model.usersLoaded == nil {
            ProgressView()
                .navigationBarHidden(true)
        } else {
            
            if model.matches.count == 0 {
                Text("No available matches")
            } else {
                //view with matches
                VStack {
                    //top bar
                    HStack {
                        Text(model.matches[index].name)
                            .frame(alignment: .leading)
                            .font(.title)
                        
                        Text(model.matches[index].gender)
                        Text("wants \(model.matches[index].datingPreferences)")
                        
                        Button(action: {
                            //action to block or report user
                        }, label: {
                            Image(systemName: "ellxipsis")
                        })
                    }
                    
                    //scroll MAIN view
                    
                    ScrollViewReader {ProxyReader in
                        ScrollView(.vertical, showsIndicators: false, content: {
                            
                            //first block
                            VStack {
                                Group {
                                    
                                    //IOS15 AsyncImage(url: URL(string: "https://your_image_url_address"))
                                    if model.matches[index].imageUrl1 == "" {
                                        Image("noPic")
                                        
                                            .resizable()
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //.aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                        
                                    } else {
                                        
                                        RemoteImage(url: model.matches[index].imageUrl1!)
                                        //.aspectRatio(contentMode: .fit)
                                        
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    //open modal to send message
                                                    likeModal.toggle()
                                                }, label: {
                                                    Image(systemName: "heart.fill")
                                                })
                                                    .fullScreenCover(isPresented: $likeModal, content: {
                                                        //FullScreenModalView.init()
                                                        LikeScreenModalView.init(input: model.matches[index].imageUrl1!, receiver: model.matches[index].id)
                                                    })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                        
                                    }
                                    
                                    Text("What would you do if you only have 1 day left to live?")
                                    Text(model.matches[index].Q1day2live ?? "")
                                }
                                .padding()
                                
                                Group {
                                    //CustomImageView(urlString: model.matches[index].imageUrl2 ?? "")
                                    if model.matches[index].imageUrl2 == "" {
                                        Image("noPic")
                                            .resizable()
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .padding(10)
                                            .cornerRadius(10)
                                    } else {
                                        
                                        RemoteImage(url: model.matches[index].imageUrl2!)
                                        //.aspectRatio(contentMode: .fit)
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .padding(10)
                                    }
                                    Text("What would you do if you won 100 million dollars?")
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
                                        
                                        Text("What would you do with your time if money was not an issue")
                                        Text(model.matches[index].QmoneynotanIssue)
                                        
                                    }
                                }
                                
                                Group {
                                    //CustomImageView(urlString: model.matches[index].imageUrl3 ?? "")
                                    if model.matches[index].imageUrl3 == "" {
                                        //?
                                    } else {
                                        
                                        RemoteImage(url: model.matches[index].imageUrl3!)
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .padding(10)
                                    }
                                    Text("What are three things in your bucket list?")
                                    Text(model.matches[index].bucketList)
                                }.padding()
                                
                                Group {
                                    
                                    if model.matches[index].imageUrl4 == "" {
                                        //                                        Image("noPic")
                                        //                                            .resizable()
                                        //                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //                                            .padding(10)
                                        //                                            .cornerRadius(10)
                                    } else {
                                        
                                        RemoteImage(url: model.matches[index].imageUrl4!)
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .padding(10)
                                    }
                                    Text("Do you know any jokes")
                                    Text(model.matches[index].jokes)
                                }.padding()
                                
                            }
                            .id("SCROLL_TO_TOP")
                            
                            
                            
                        })//scroll view
                        //to recreate the veiw from scratch
                            .id(self.scrollViewID)
                        //this is to show the rejection button
                            .overlay(
                                Button(action: {
                                    //move to the next match
                                    self.transitionShown.toggle()
                                    self.viewShown.toggle()
                                    
                                    
                                    //scroll to top
                                    withAnimation(.spring()) {
                                        ProxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                                        
                                        if self.index == model.matches.count-1 {
                                            //go back to first match
                                            self.index = 0
                                        } else {
                                            self.index += 1
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.transitionShown.toggle()
                                        self.viewShown.toggle()
                                    }
                                    
                                    
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:50, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                })
                                    .padding(.trailing)
                                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0) //this is an if statement
                                //.opacity(-scrollViewOffset > 450 ? 1 : 0)
                                    .animation(.easeInOut)
                                
                                //to show rejection transition
                                    .fullScreenCover(isPresented: $transitionShown, content: {
                                        RejectionModalView.init()
                                        
                                    })
                                
                                
                                //fixing at bottom left the floating rejection !!
                                , alignment: .bottomLeading
                                
                            )
                        //right accept button
                            .overlay(
                                Button(action: {
                                    //show toggle to send a messaage
                                    
                                    
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:50, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                })
                                    .padding(.trailing)
                                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0) //this is an if statement
                                //.opacity(-scrollViewOffset > 450 ? 1 : 0)
                                    .animation(.easeInOut)
                                
                                //to show rejection transition
                                    .fullScreenCover(isPresented: $transitionShown, content: {
                                        RejectionModalView.init()
                                        
                                    })
                                
                                //fixing at bottom left the floating like !!
                                , alignment: .bottomTrailing
                                
                            )
                        
                    }
                } //vStack main matches view
                .opacity(viewShown ? 0 : 1)
                .navigationBarHidden(true)
            }
        }
    }
    
}

//rejection
struct RejectionModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.system(size:50, weight: .semibold))
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
    }
}

//accept/like/send message
struct LikeScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var chatModel: ChatsViewModel
    
    @State var opener: String = ""
    var input : String
    var receiver: String
    
    var body: some View {
        VStack {
            //object reference for opener
            RemoteImage(url: input)
            
            TextField("Say something nice", text: $opener).font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                //write in firebase a new conversation
                let user = UserService.shared.user
                print(user.id)
                chatModel.startConversation(sender: user.id, receiver: receiver, message: opener)
            } label: {
                Text("Send Message")
            }

            
            
        }

        
        
    }
}


//extension view to get saferarea
extension View{
    func getSafeArea()->UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(index: 0)
            .environmentObject(ContentModel())
    }
}
