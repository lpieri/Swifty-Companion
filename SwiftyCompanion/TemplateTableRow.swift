//
//  TemplateTableRow.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableRow: View {
    var body: some View {
        
        HStack {
            Text("ProjectName")
                .font(.headline)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Text("ProjectGrade")
                .multilineTextAlignment(.trailing)
        }.padding()
        
    }
}

struct TemplateTableRow_Previews: PreviewProvider {
    static var previews: some View {
        TemplateTableRow()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
