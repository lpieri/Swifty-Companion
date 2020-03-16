//
//  TemplateTableView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableView: View {
    
    var title: String
    var data: [UserData]
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack (alignment: .leading, spacing: 2) {

                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                List (data, id: \.name) { dataRow in
                    TemplateTableRow(data: dataRow)
                }
                
            }.padding()
            .frame(height: 250)
        }
    }
}

struct TemplateTableView_Previews: PreviewProvider {
    
    static var previews: some View {
        TemplateTableView(title: "Projects", data: [UserData]()).environment(\.colorScheme, .dark)
    }
}
