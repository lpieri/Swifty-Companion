//
//  LevelBar.swift
//  SwiftyCompanion
//
//  Created by Louise on 16/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct LevelBar: View {
    
    var levelProgess: CGFloat
    
    var body: some View {
        ZStack (alignment: .leading) {
            GeometryReader { geometry in

                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                    .frame(height: 35.0)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.green)
                    .frame(width: geometry.size.width/100*self.levelProgess, height: 35.0)
                
            }.frame(height: 35)
        }.padding()
    }
}

struct LevelBar_Previews: PreviewProvider {
    static var previews: some View {
        LevelBar(levelProgess: 99)
    }
}
