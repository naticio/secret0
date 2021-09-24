//
//  ChatRow.swift
//  Secret0
//
//  Created by Nat-Serrano on 9/23/21.
//

import SwiftUI

struct ChatRow: View {
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading, spacing: 5){
                    HStack {
                        Text("Nat")
                            .bold()
                        Spacer()
                        Text("Date")
                    }
                    
                    HStack {
                        Text("dhfkjhsfkjhsdfkjhdskjfhdkjfhdksjhfksdjzhf")
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(height:50, alignment: .top)
                            .padding(.trailing,40)
                    }
                }
            }
        }
        .frame(height:80)
    }
    
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow()
    }
}
