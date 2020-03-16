//
//  TemplateTableView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableView: View {
    
    var data: [Project]
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Project")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            List (data, id: \.projectName) { dataRow in
                TemplateTableRow(data: dataRow)
            }
            
        }.padding()
        
    }
}

struct TemplateTableView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateTableView(data: [Project]())
    }
}
