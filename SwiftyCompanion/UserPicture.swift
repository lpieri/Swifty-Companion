//
//  UserPicture.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct UserPicture: View {
    
    var image: Image
    
    var body: some View {
        
        self.image
            .resizable()
            .frame(minWidth: 0, maxWidth: 142, minHeight: 0, maxHeight: 142)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 4)
    }
}

struct UserPicture_Previews: PreviewProvider {
    static var previews: some View {
        UserPicture(image: Image("pp"))
    }
}
