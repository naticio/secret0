//
//  ProfileView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    @State private var scrollViewID = UUID()
    @State private var reader: ScrollViewProxy?
    
    @State var profileUser : User
    
    @State private var tabBar: UITabBar! = nil
    
    var body: some View {
        
        //Header
        VStack {
            Group {
                HStack {
                    Text(profileUser.name)
                        .frame(alignment: .leading)
                        .font(.title.bold())
                        .padding(.leading)
                    
                    Spacer()
                    Menu(content: {
                        Button {
                            
                        } label: {
                            Text("Block")
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Report")
                        }
                    }, label: {
                        Image(systemName: "ellipsis")
                    })
                    .padding(.trailing)
                }
            }
            
            //scroll MAIN view
            
            ScrollViewReader {ProxyReader1 in
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack {
                       Group {
                            if profileUser.imageUrl1 == "" {
                                Image("noPic")
                                    .resizable()
                                    .frame(height: 410, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    //.aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .padding(10)
                                    .shadow(radius: 5)
                                
                            } else {
                                
                                WebImage(url: URL(string: profileUser.imageUrl1!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .padding(10)
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
                                    
                                    Text(profileUser.Q1day2live ?? "")
                                        .font(Font.system(size: 14))
                                        .padding([.top, (.horizontal)])
                                    
                                    
                                }
                                .cornerRadius(15)

                                
                            }
                        }.padding(.horizontal,13)
                        
                        
                        ///3RD GROUP IMAGE
                        Group {
                            if profileUser.imageUrl2 == "" {

                            } else {
                                
                                WebImage(url: URL(string: profileUser.imageUrl2!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .padding(10)
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
                                            Text(String(profileUser.birthdate.age))
                                        }.padding(.trailing)
                                        
                                        Group {
                                            Image(systemName: "ruler")
                                            Text(getInches(height: profileUser.height))
                                            
                                        }.padding(.trailing)
                                        
                                        Group {
                                            Image(systemName: "mappin.and.ellipse")
                                            Text(profileUser.city!)
                                        }
                                    }
                                    .padding()
                                    //.border(Color.gray)
                                    
                                }
                            }
                            
                            
                        }.padding(.horizontal, 13)

                        
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
                                    
                                    Text(profileUser.QmoneynotanIssue)
                                        .font(Font.system(size: 14))
                                        .padding([.top, (.horizontal)])
                                }.padding()
                                //.border(Color.gray)
                            }
                            
                        }.padding(.horizontal,13)
                        
                        //IMAGE - 3
                        Group {
                            if profileUser.imageUrl3 == "" {
                                //print("no image 3")
                            } else {

                                WebImage(url: URL(string: profileUser.imageUrl3!))
//                                            .frame(height: 410, alignment: .center)
//                                            .padding(10)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .padding(10)
                            }

                        }//.padding(.horizontal,5)
                        
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
                                    Text(profileUser.bucketList)
                                        .font(Font.system(size: 14))
                                        .padding([.top, (.horizontal)])
                                }
                                .padding()
                                
                            }
                            
                        }.padding(.horizontal,13)
                        
                        //IMAGE - 4
                        Group {
                            
                            if profileUser.imageUrl4 == "" {

                            } else {
                                
                                WebImage(url: URL(string: profileUser.imageUrl4!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .padding(10)
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
                                    Text(profileUser.jokes)
                                }
                                .padding()
                                //.border(Color.gray)
                                //.scaledToFit()
                                
                            }
                        }.padding(.horizontal,13)
                        
                        if UserService.shared.user.name == profileUser.name {
                            Group {
                                VStack {
                                    Button {
                                        //sign out the user
                                        try! Auth.auth().signOut() //we're using try because we're not interested to catch an error when signin out
                                        
                                        isOnboarding = false
                                        model.usersLoaded =  false
                                        //UserService.shared.user.name = ""
                                        model.checkLogin()
                                        //change to log out view
                                        //model.loggedIn = false
                                        
                                    } label: {
                                        Text("Sign Out")
                                    }
                            
                                    
                                    //Text("User logged in: \(UserService.shared.user.name)")
                                }

                            }
                        }

                    }
                    .id("SCROLL_TO_TOP")
                    .background(Color(.systemGroupedBackground))
                    
                    
                    
                })//scroll view
                .id(self.scrollViewID)
            }
        } //vStack main matches view
//        .onAppear() {
//            model.getUserData()
//        }

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
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(profileUser: )
//    }
//}
