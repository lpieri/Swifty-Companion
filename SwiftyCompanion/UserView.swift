//
//  UserView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct UserView: View {
    var user: User
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                UserPicture(image: user.image)
                
                VStack(alignment: .leading)  {
                    
                    Text(user.login)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(user.email)
                        .font(.headline)
                    
                    Text(user.location)
                        .font(.subheadline)
                    
                }.frame(minWidth: 0, maxWidth: .infinity)
                    
            }
            
            VStack {
                Text("Level: \(user.level)")
                    .font(.headline)
                
                RoundedRectangle(cornerRadius: 35)
                    .foregroundColor(.green)
                    .frame(height: 35.0)
            }
            
            Spacer()
            
        }.padding()
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(login: "cpieri", displayName: "Louise Pieri",
                            email: "cpieri@student.42.fr", location: "z2r2p2.le-101.fr",
                            level: 15.15, image: Image("pp"),
                            projects: [{"Swifty-Companion"; 125}])!)
    }
}
