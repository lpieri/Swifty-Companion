//
//  TemplateTableRow.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableRow: View {
    
    var data: Project
    
    var body: some View {
        
        HStack {
            Text(data.projectName)
                .font(.headline)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            getGrade(projectData: data)
        }.padding()
        
    }
    
    func getGrade(projectData: Project) -> Text {
        if projectData.projectValidated == true {
            return Text("\(projectData.projectGrade.intValue)").foregroundColor(.green)
        } else if projectData.projectState == "finished" {
            return Text("Failed").foregroundColor(.red)
        }
        return Text(projectData.projectState)
    }
    
}

struct TemplateTableRow_Previews: PreviewProvider {
    static var previews: some View {
        TemplateTableRow(data: Project(projectName: "Swift", projectState: "finished", projectGrade: NSNumber(125), projectValidated: true))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
