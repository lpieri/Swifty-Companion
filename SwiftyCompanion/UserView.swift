//
//  UserView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        
        VStack {
            UserProfile(user: user)

//            ScrollView (.vertical) {
//                VStack (spacing: 12) {
//                    Spacer()
            TemplateTableView(data: user.projects).frame(minHeight: 0, maxHeight: 300)
//                    Spacer()
//                    TemplateTableView(data: user.projects)
//                }
//            }
            
            Spacer()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(User())
    }
}
