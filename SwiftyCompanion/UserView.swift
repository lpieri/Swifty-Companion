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

            ScrollView (.vertical) {
                
                TemplateTableView(title: "Projects", data: user.projects)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 250)
                
                Spacer()

                TemplateTableView(title: "Skills", data: user.skills)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 250)

            }
            
//            Spacer()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(User())
    }
}
