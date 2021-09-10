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
            LoadingView()
        } else {
            VStack {
                //top bar
                HStack {
                    Text(model.matches[index].name)
                        .frame(alignment: .leading)
                        .font(.title)
                    
                    Button(action: {
                        //action to block or report user
                    }, label: {
                        Image(systemName: "ellipsis")
                    })
                }
                
                //scroll MAIN view
                ScrollView {
                    
                    //first block
                    VStack {
                        Group {
                            Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(model.matches[index].Q1day2live ?? "")
                        }.padding()
                        
                        Group {
                            Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                            Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(model.matches[index].bucketList)
                        }.padding()
                        
                        Group {
                            Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(model.matches[index].jokes)
                        }.padding()
                        
                        Button {
                            self.index += 1
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

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(index: 0)
    }
}
