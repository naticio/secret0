//
//  MatchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MatchView: View {
    
    @EnvironmentObject var model: ContentModel
    //@EnvironmentObject var chatModel: ChatsViewModel
    
    //to hide view
    @State var viewShown = false
    @State var transitionShown = false
    
    //modal like
    @State var likeModal = false
    
    //alert for blocked users
    @State private var showingAlert = false

    
    
    @State var index : Int
    @State var image1: String = ""
    @State var goWhenTrue: Bool = false
    
    @State private var scrollViewID = UUID()
    @State private var reader: ScrollViewProxy?
    @State private var viewAllMatches = false
    @State var openerInput: String = ""
    
    @State private var sort: Int = 0
    
    //@State var currentUser = UserService.shared.user
    //    init() {
    //            // Use this if NavigationBarTitle is with large font
    //            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
    //        }
    
    var body: some View {
        
        
        if model.usersLoaded == nil || model.usersLoaded == false {
            ProgressView()
                .navigationBarHidden(true)
        } else {
            
            if model.matches.count == 0 || viewAllMatches ==  true || index >= model.matches.count  {
                Text("No available matches")
            } else {
                //view with matches
                //top bar
                //                NavigationView{
                VStack {
                    HStack {
                        Text(model.matches[index].name)
                            .frame(alignment: .leading)
                            .font(.title.bold())
                            .padding(.leading)
                        
                        Spacer()
                        Menu(content: {
                            //MARK: - BLOCK USER
                            Button {
                                //write in current user, user block.append match.name
                                model.blockUser(userToBlock: model.matches[index].name, type: "block")
                                
                                self.transitionShown.toggle()
                                self.viewShown.toggle()
                                
                                self.scrollViewID = UUID()

                                    if self.index == model.matches.count-1 {
                                        //go back to first match
                                        self.index = 0
                                    } else {
                                        self.index += 1
                                    }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.transitionShown.toggle()
                                    self.viewShown.toggle()
                                    
                                }
                            
                            } label: {
                                Text("Block")
                            }
                            
                            //MARK: - REPORT USER
                            Button {
                                model.blockUser(userToBlock: model.matches[index].name, type: "reported")
                                
                                self.transitionShown.toggle()
                                self.viewShown.toggle()
                                
                                self.scrollViewID = UUID()

                                    if self.index == model.matches.count-1 {
                                        //go back to first match
                                        self.index = 0
                                    } else {
                                        self.index += 1
                                    }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.transitionShown.toggle()
                                    self.viewShown.toggle()
                                    
                                }
                                
                            } label: {
                                Text("Report")
                            }

                            //Text("Like")
                        }, label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large) //so  Ican easily click on it
                                .padding()
                        })
                        .padding(.trailing)
                        .accentColor(.black)
                    }
                    
                    
                    //scroll MAIN view
                    
                    ScrollViewReader {ProxyReader in
                        ScrollView(.vertical, showsIndicators: false, content: {
                            
                            LazyVStack {
                                Group {
                                    
                                    //IOS15 AsyncImage(url: URL(string: "https://your_image_url_address"))
                                    if model.matches[index].imageUrl1 == "" {
                                        Image("noPic")
                                            .resizable()
                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            //.aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .shadow(radius: 5)
                                        
                                    } else {
                                        
                                        WebImage(url: URL(string: model.matches[index].imageUrl1!))
                                            //                                            .frame(height: 410, alignment: .center)
                                            //                                            .padding(10)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    //if current user is in blocked_users from match then send popup bLOCKED
                                                    if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                        showingAlert = true
                                                    } else {
                                                        openerInput = model.matches[index].imageUrl1!
                                                        //open modal to send message
                                                        likeModal.toggle()
                                                    }

                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                .alert(isPresented: $showingAlert) {
                                                            Alert(title: Text("You're blocked by this user"), message: Text("Be nice next time"), dismissButton: .default(Text("OK")))
                                                        }
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Image", question: "", receiverImage: model.matches[index].imageUrl1!, picNumber: 1)
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                        
                                        //                                            RemoteImage(url: model.matches[index].imageUrl1!)
                                        //                                                //.aspectRatio(contentMode: .fit)
                                        //
                                        //                                                .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //                                                .cornerRadius(10)
                                        //                                                .padding(10)
                                        
                                        
                                    }
                                    
                                    
                                }.padding(.horizontal,5)
                                
                                
                                //2nd group with text
                                Group{
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                                        
                                        VStack {
                                            Text("What would you do if you only have 1 day left to live?")
                                                .font(.title2)
                                                .bold()
                                                .padding(.horizontal, 5)
                                            
                                            
                                            Text(model.matches[index].Q1day2live ?? "")
                                                //.padding()
                                                .font(Font.system(size: 14))
                                                .padding([.top, (.horizontal)])
                                            
                                            
                                        }
                                        .cornerRadius(15)
                                        //.padding(.horizontal, 10)
                                        
                                    }
                                    .overlay(
                                        Button(action: {
                                            if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                showingAlert = true
                                            } else {
                                                openerInput = model.matches[index].Q1day2live
                                                likeModal.toggle()
                                            }

                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Text", question: "What would you do if you only have 1 day left to live?", receiverImage: model.matches[index].imageUrl1!, picNumber: 0)
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )
                                }.padding(.horizontal,13)
                                
                                
                                ///3RD GROUP IMAGE
                                Group {
                                    //CustomImageView(urlString: model.matches[index].imageUrl2 ?? "")
                                    if model.matches[index].imageUrl2 == "" {
                                        //                                        Image("noPic")
                                        //                                            .resizable()
                                        //                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //                                            .padding(10)
                                        //                                            .cornerRadius(10)
                                        //                                            .shadow(radius: 5)
                                    } else {
                                        
                                        WebImage(url: URL(string: model.matches[index].imageUrl2!))
                                            //                                            .frame(height: 410, alignment: .center)
                                            //                                            .padding(10)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                        showingAlert = true
                                                    } else {
                                                        openerInput = model.matches[index].imageUrl2!
                                                        likeModal.toggle()
                                                    }

                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput , receiver: model.matches[index].name, type: "Text", question: "", receiverImage: model.matches[index].imageUrl1!, picNumber: 2)
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    
                                    
                                }.padding(.horizontal, 5)
                                
                                //4th HSTACK match data
                                Group {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .aspectRatio(CGSize(width: 335, height: 50), contentMode: .fit)
                                        
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
                                                    Text(model.matches[index].city!)
                                                }
                                            }
                                            .padding()
                                            //.border(Color.gray)
                                            
                                        }
                                    }
                                    
                                    
                                }.padding(.horizontal, 13)
                                
                                //text
                                /*Group {
                                 ZStack {
                                 Rectangle()
                                 .foregroundColor(.white)
                                 .cornerRadius(10)
                                 .shadow(radius: 5)
                                 .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                                 
                                 VStack{
                                 Text("What would you do if you won 100 million dollars?")
                                 .font(.title2)
                                 .bold()
                                 .padding(.horizontal, 5)
                                 
                                 Text(model.matches[index].QlotteryWin ?? "")
                                 .font(Font.system(size: 14))
                                 .padding([.top, (.horizontal)])
                                 }
                                 .padding()
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
                                 
                                 }.padding(.horizontal,13)*/
                                
                                //QUESTION - money not an issue
                                Group {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                                        
                                        VStack{
                                            Text("What would you do with your time if money was not an issue?")
                                                .font(.title2)
                                                .bold()
                                                .padding(.horizontal, 5)
                                            
                                            Text(model.matches[index].QmoneynotanIssue)
                                                .font(Font.system(size: 14))
                                                .padding([.top, (.horizontal)])
                                        }.padding()
                                        //.border(Color.gray)
                                        .overlay(
                                            Button(action: {
                                                //if current user is in blocked_users from match then send popup bLOCKED
                                                if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                    showingAlert = true
                                                } else {
                                                    openerInput = model.matches[index].QmoneynotanIssue
                                                    //open modal to send message
                                                    likeModal.toggle()
                                                }

                                            }, label: {
                                                Image("corazon")
                                                    .foregroundColor(Color(.systemRed))
                                            })
                                            //MARK: - like button
                                            .fullScreenCover(isPresented: $likeModal, content: {
                                                LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Text", question: "What would you do with your time if money was not an issue?", receiverImage: model.matches[index].imageUrl1!, picNumber: 0)
                                                    .environmentObject(ChatsViewModel())
                                                    .environmentObject(ContentModel())
                                            })
                                            
                                            //fixing at bottom left the floating like !!
                                            , alignment: .bottomTrailing
                                        )
                                    }
                                    
                                }.padding(.horizontal,13)
                                
                                //IMAGE - 3
                                Group {
                                    if model.matches[index].imageUrl3 == "" {

                                    } else {
                                        
                                        WebImage(url: URL(string: model.matches[index].imageUrl3!))
                                            //                                            .frame(height: 410, alignment: .center)
                                            //                                            .padding(10)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    //if current user is in blocked_users from match then send popup bLOCKED
                                                    if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                        showingAlert = true
                                                    } else {
                                                        openerInput = model.matches[index].imageUrl3!
                                                        //open modal to send message
                                                        likeModal.toggle()
                                                    }

                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Text", question: "", receiverImage: model.matches[index].imageUrl1!, picNumber: 3)
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    
                                }.padding(.horizontal,5)
                                
                                //QUESTION - bucket list
                                Group {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                                        
                                        VStack {
                                            Text("What are three things in your bucket list?")
                                                .font(.title2)
                                                .bold()
                                                .padding(.horizontal, 5)
                                            Text(model.matches[index].bucketList)
                                                .font(Font.system(size: 14))
                                                .padding([.top, (.horizontal)])
                                        }
                                        .padding()
                                        
                                    }
                                    .overlay(
                                        Button(action: {
                                            //if current user is in blocked_users from match then send popup bLOCKED
                                            if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                showingAlert = true
                                            } else {
                                                openerInput = model.matches[index].QlotteryWin
                                                //open modal to send message
                                                likeModal.toggle()
                                            }

                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].bucketList, type: "Text", question: "What are three things in your bucket list?", receiverImage: model.matches[index].imageUrl1!, picNumber: 0)
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )
                                    
                                }.padding(.horizontal,13)
                                
                                //IMAGE - 4
                                Group {
                                    
                                    if model.matches[index].imageUrl4 == "" {
                                        //                                        Image("noPic")
                                        //                                            .resizable()
                                        //                                            .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //                                            .cornerRadius(10)
                                        //                                            .padding(10)
                                        //                                            .shadow(radius: 5)
                                    } else {
                                        
                                        WebImage(url: URL(string: model.matches[index].imageUrl4!))
                                            //                                            .frame(height: 410, alignment: .center)
                                            //                                            .padding(10)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .padding(10)
                                            .overlay(
                                                Button(action: {
                                                    //if current user is in blocked_users from match then send popup bLOCKED
                                                    if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                        showingAlert = true
                                                    } else {
                                                        openerInput = model.matches[index].imageUrl4!
                                                        //open modal to send message
                                                        likeModal.toggle()
                                                    }

                                                }, label: {
                                                    Image("corazon")
                                                        .foregroundColor(Color(.systemRed))
                                                })
                                                //MARK: - like button
                                                .fullScreenCover(isPresented: $likeModal, content: {
                                                    LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Text", question: "", receiverImage: model.matches[index].imageUrl1!, picNumber: 4)
                                                        .environmentObject(ChatsViewModel())
                                                        .environmentObject(ContentModel())
                                                })
                                                
                                                //fixing at bottom left the floating like !!
                                                , alignment: .bottomTrailing
                                            )
                                    }
                                    
                                    
                                }.padding(.horizontal,5)
                                
                                //QUESTION - Jokes
                                Group{
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                                        
                                        VStack{
                                            Text("Do you know any jokes?")
                                                .font(.title2)
                                                .bold()
                                                .padding(.bottom)
                                            Text(model.matches[index].jokes)
                                        }
                                        .padding()
                                        //.border(Color.gray)
                                        //.scaledToFit()
                                        
                                    }
                                    .overlay(
                                        Button(action: {
                                            //if current user is in blocked_users from match then send popup bLOCKED
                                            if model.matches[index].blocked_users!.contains(UserService.shared.user.name) {
                                                showingAlert = true
                                            } else {
                                                openerInput = model.matches[index].jokes
                                                //open modal to send message
                                                likeModal.toggle()
                                            }

                                        }, label: {
                                            Image("corazon")
                                                .foregroundColor(Color(.systemRed))
                                        })
                                        //MARK: - like button
                                        .fullScreenCover(isPresented: $likeModal, content: {
                                            LikeScreenModalView.init(likeModalShown: $likeModal, indexHere: $index, input: $openerInput, receiver: model.matches[index].name, type: "Text", question: "Do you know any jokes?", receiverImage: model.matches[index].imageUrl1!, picNumber: 0)
                                                .environmentObject(ChatsViewModel())
                                                .environmentObject(ContentModel())
                                        })
                                        
                                        //fixing at bottom left the floating like !!
                                        , alignment: .bottomTrailing
                                    )
                                }.padding(.horizontal,13)
                                
                            }
                            .id("SCROLL_TO_TOP")
                            .background(Color(.systemGroupedBackground))
                            
                            
                            
                        })//scroll view
                        //to recreate the veiw from scratch
                        .id(self.scrollViewID)
                        
                        //MARK: - rejection button
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
                                    .font(.system(size:65, weight: .semibold))
                                    .foregroundColor(.black)
                                    //.padding(0)
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
                }
                .opacity(viewShown ? 0 : 1)
                .navigationBarTitle(Text(model.matches[index].name).font(.subheadline), displayMode: .large)
                //                    .toolbar {
                //                        ToolbarItem(placement: .navigationBarTrailing) {
                //                            Menu(content: {
                //                                Text("Menu Item 1")
                //                                Text("Menu Item 2")
                //                                Text("Menu Item 3")
                //                            }, label: {Image(systemName: "ellipsis")})
                //                        }
                //                    }
                //                    //.ignoresSafeArea(.top)
                //                }
                
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
    @Binding var input : String
    var receiver: String
    var type: String
    var question: String
    var receiverImage: String
    var picNumber: Int
    
    var body: some View {
        VStack {
            //object reference for opener
            if type == "Image" {
                WebImage(url: URL(string: input))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(10)
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
                DispatchQueue.main.async {
                    if indexHere == model.matches.count-1 {
                        //go back to first match
                        indexHere = 0
                    } else {
                        indexHere += 1
                    }
                }
                
                
                likeModalShown.toggle() //flip to false
                
                chatModel.startConversation(receiver: receiver, message: opener, receiverImg: receiverImage)
                
                
            } label: {
                Text("Send Message")
            }.padding()
            
            Button("I chickened out...") {
                presentationMode.wrappedValue.dismiss()
            }.padding()
            
            
            
        }
        
        
        
    }
}


//extension view to get saferarea
extension View{
    func getSafeArea()->UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchView(index: 0)
//            .environmentObject(ContentModel())
//    }
//}
