//
//  TemplateTableRow.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableRow: View {
    
    var data: UserData
    
    var body: some View {
        
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            HStack {
                Text(data.name)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                getGrade(data: data)
            }.padding()
        }
        
    }
    
    func getGrade(data: UserData) -> Text {
        if data.validated == true {
            return Text("\(data.grade.intValue)").foregroundColor(.green)
        } else if data.state == "finished" {
            return Text("Failed").foregroundColor(.red)
        } else if data.state == "skill" {
            return Text("\(data.grade.floatValue)")
        }
        return Text(data.state)
    }
    
}

struct TemplateTableRow_Previews: PreviewProvider {
    static var previews: some View {
        TemplateTableRow(data: UserData())
            .previewLayout(.fixed(width: 300, height: 70))
            .environment(\.colorScheme, .dark)
    }
}
