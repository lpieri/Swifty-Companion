//
//  UserProfile.swift
//  SwiftyCompanion
//
//  Created by Louise on 16/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    
    var user: User
    
    var body: some View {
        
        VStack {
             HStack {
                UserPicture(image: user.image)
                VStack(alignment: .leading)  {
                    Text(user.login)
                        .font(.title)
                        .fontWeight(.semibold)
                    Text(user.displayName)
                    Text(user.email)
                        .font(.headline)
                    Text(user.location)
                        .font(.subheadline)
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
            
            VStack {
                Text("Level: \(user.level)")
                    .font(.headline)
                LevelBar(levelProgess: user.levelProgress)
            }
            
        }.padding()
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(user: User())
    }
}
