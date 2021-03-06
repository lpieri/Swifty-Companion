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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack: some View {
        Button(action: {
            self.user.isActive = false
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                UserProfile(user: user)

                ScrollView (.vertical) {
                    
                    TemplateTableView(title: "Projects", data: user.projects)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minHeight: 250, maxHeight: 500)
                    
                    Spacer()

                    TemplateTableView(title: "Skills", data: user.skills)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minHeight: 250, maxHeight: 500)
                    
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: btnBack)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(User()).environment(\.colorScheme, .dark)
    }
}
