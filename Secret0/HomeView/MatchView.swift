//
//  MatchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI

struct MatchView: View {
    
    @EnvironmentObject var model: ContentModel
    //@EnvironmentObject var chatModel: ChatsViewModel
    
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
            
            if model.matches.count == 0 || (model.matches.count == index) {
                Text("No available matches")
            } else {
                //view with matches
                //top bar
                VStack {
                    Group {
                        HStack {
                            Text(model.matches[index].name)
                                .frame(alignment: .leading)
                                .font(.title.bold())
                                
                            
                            Text(model.matches[index].gender)
                            Text("wants \(model.matches[index].datingPreferences)")
                            
                            Button(action: {
                                //action to block or report user
                            }, label: {
                                Image(systemName: "ellxipsis")
                            })
                        }
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
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].imageUrl1!, receiver: model.matches[index].name, type: "Image", question: "")
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                        
                                    }
                                    
                                    
                                }.padding(.horizontal)
                                
                                
                                //2nd group with text
                                Group {
                                    VStack {
                                        Text("What would you do if you only have 1 day left to live?")
                                            .font(.title2)
                                            .bold()
                                            .padding(.bottom)
                                        
                                        Text(model.matches[index].Q1day2live ?? "")
            
                                    }
                                    .padding()
                                    .border(Color.gray)
                                    //.cornerRadius(5)
                                    .overlay(
                                        Button(action: {
                                            //open modal to send message
                                            likeModal.toggle()
                                            
                                            
                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].Q1day2live, receiver: model.matches[index].name, type: "Text", question: "What would you do if you only have 1 day left to live?")
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )
                                    
                                    
                                }
                                .padding(.horizontal)

                                
                                ///3RD GROUP IMAGE
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
                                            .overlay(
                                                Button(action: {
                                                    //open modal to send message
                                                    likeModal.toggle()
                                                    
                                                    
                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].imageUrl2!, receiver: model.matches[index].name, type: "Text", question: "")
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    VStack{
                                        Text("What would you do if you won 100 million dollars?")
                                            .font(.title2)
                                            .bold()
                                            .padding(.bottom)
                                        Text(model.matches[index].QlotteryWin ?? "")
                                    }.padding()
                                    .border(Color.gray)
                                    .overlay(
                                        Button(action: {
                                            //open modal to send message
                                            likeModal.toggle()
                                            
                                            
                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].QlotteryWin, receiver: model.matches[index].name, type: "Text", question: "What would you do if you won 100 million dollars")
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )
                                    

                                }
                                .padding(.horizontal)
                                //add overlay
                                
                                //4th group quest
                                Group {
                                    VStack {
                                        HStack {
                                            Group {
                                                Image(systemName: "sun.min")
                                                //let age = getAge(dateBirth: model.matches[index].birthdate)
                                                Text(String(model.matches[index].birthdate.age))
                                            }.padding(.trailing)
                                            
                                            Group {
                                                Image(systemName: "ruler")
                                                Text(getInches(height: model.matches[index].height))
                                                //Text(String(model.matches[index].height) ?? "")
                                            }.padding(.trailing)
                                            
                                            Group {
                                                Image(systemName: "mappin.and.ellipse")
                                                Text("Location")
                                            }
                                        }
                                        .padding()
                                        .border(Color.gray)
                                        
                                        VStack{
                                            Text("What would you do with your time if money was not an issue?")
                                                .font(.title2)
                                                .bold()
                                                .padding(.bottom)
                                            Text(model.matches[index].QmoneynotanIssue)
                                        }.padding()
                                        .border(Color.gray)
                                        .overlay(
                                            Button(action: {
                                                //open modal to send message
                                                likeModal.toggle()
                                                
                                                
                                            }, label: {
                                                Image("corazon")
                                                    .foregroundColor(Color(.systemRed))
                                            })
                                            //MARK: - like button
                                            .fullScreenCover(isPresented: $likeModal, content: {
                                                LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].QmoneynotanIssue, receiver: model.matches[index].name, type: "Text", question: "What would you do with your time if money was not an issue?")
                                                    .environmentObject(ChatsViewModel())
                                                    .environmentObject(ContentModel())
                                            })
                                            
                                            //fixing at bottom left the floating like !!
                                            , alignment: .bottomTrailing
                                        )
                                        
                                    }

                                }
                                .padding(.horizontal)
                                //add overlay for the LIKE
                                
                                Group {
                                    //CustomImageView(urlString: model.matches[index].imageUrl3 ?? "")
                                    if model.matches[index].imageUrl3 == "" {
                                        //?
                                    } else {
                                        
                                        RemoteImage(url: model.matches[index].imageUrl3!)
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    //open modal to send message
                                                    likeModal.toggle()
                                                    
                                                    
                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].imageUrl3!, receiver: model.matches[index].name, type: "Text", question: "")
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    VStack {
                                        Text("What are three things in your bucket list?")
                                            .font(.title2)
                                            .bold()
                                            .padding(.bottom)
                                        Text(model.matches[index].bucketList)
                                    }
                                    .padding()
                                    .border(Color.gray)
                                    .overlay(
                                        Button(action: {
                                            //open modal to send message
                                            likeModal.toggle()
                                            
                                            
                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].QlotteryWin, receiver: model.matches[index].bucketList, type: "Text", question: "What are three things in your bucket list?")
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )

                                }
                                .padding(.horizontal)
                                //add overlay
                                
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
                                            .overlay(
                                                Button(action: {
                                                    //open modal to send message
                                                    likeModal.toggle()
                                                    
                                                    
                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].imageUrl4!, receiver: model.matches[index].name, type: "Text", question: "")
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    VStack{
                                        Text("Do you know any jokes?")
                                            .font(.title2)
                                            .bold()
                                            .padding(.bottom)
                                        Text(model.matches[index].jokes)
                                    }
                                    .padding()
                                    .border(Color.gray)
                                    .overlay(
                                        Button(action: {
                                            //open modal to send message
                                            likeModal.toggle()
                                            
                                            
                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: model.matches[index].jokes, receiver: model.matches[index].name, type: "Text", question: "Do you know any jokes?")
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )


                                }.padding(.horizontal)
                                
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
                        
                    }
                } //vStack main matches view
                .opacity(viewShown ? 0 : 1)
                .navigationBarHidden(true)
            }
        }
    }
    
    func getInches(height: Int) -> String {
        
        var heightInches = ""
        
        switch height {
        case 57:
            heightInches = "4'9"
        case 58:
            heightInches = "4'10"
        case 59:
            heightInches = "4'11"
        case 60:
            heightInches = "5'0"
        case 61:
            heightInches = "5'1"
        case 62:
            heightInches = "5'2"
        case 63:
            heightInches = "5'3"
        case 64:
            heightInches = "5'4"
        case 65:
            heightInches = "5'5"
        case 66:
            heightInches = "5'6"
        case 67:
            heightInches = "5'7"
        case 68:
            heightInches = "5'8"
        case 69:
            heightInches = "5'9"
        case 70:
            heightInches = "5'10"
        case 71:
            heightInches = "5'11"
        case 72:
            heightInches = "6'0"
        case 73:
            heightInches = "6'1"
        case 74:
            heightInches = "6'2"
        case 75:
            heightInches = "6'3"
        case 76:
            heightInches = "6'4"
        case 77:
            heightInches = "6'5"
        
        default:
            heightInches = ""
        }
        
        return heightInches
    }
    
//    func getAge(dateBirth: Date) -> Int {
//
//        let calendar = Calendar.current
//
//        let dateComponent = calendar.dateComponents([.year], from: dateBirth, to: Date())
//
//        return (dateComponent.year!)
//    }
    
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
    @EnvironmentObject var model: ContentModel
    
    
    @Binding var likeModalShown : Bool
    @Binding var indexHere: Int
    
    @State var opener: String = ""
    var input : String
    var receiver: String
    var type: String
    var question: String
    
    var body: some View {
        VStack {
            //object reference for opener
            
            if type == "Image" {
                RemoteImage(url: input)
            } else {
                VStack {
                    Text(input)
                }
            }
            
            
            TextField("Say something nice", text: $opener).font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                //write in firebase a new conversation
                let user = UserService.shared.user
                print(user.id)
                
                //move to next match
                if indexHere == model.matches.count-1 {
                    //go back to first match
                    indexHere = 0
                } else {
                    indexHere += 1
                }
                
                likeModalShown.toggle() //flip to false
                
                chatModel.startConversation(receiver: receiver, message: opener)
                
                
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
