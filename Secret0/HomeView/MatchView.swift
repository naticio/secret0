//
//  MatchView.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/8/21.
//

import SwiftUI

struct MatchView: View {
    var body: some View {
        VStack {
            //top bar
            HStack {
                Text("Name")
                    .frame(alignment: .leading)
                
                Button(action: {
                    
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
                        Text("First question")
                    }.padding()

                    Group {
                        Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("2nd question")
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
                                    Text("Height")
                                }.padding(.trailing)
                                
                                Group {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("Location")
                                }.padding(.trailing)
                            }
                            
                            Text("3nd question")
                            
                        }
                    }
                    
                    Group {
                        Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("4th question")
                    }.padding()
                    
                    Group {
                        Image(systemName: "person").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Jokes")
                    }.padding()
                    
                }
                    
                
                
            }//scroll view
        }
        
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
