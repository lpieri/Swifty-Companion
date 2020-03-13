//
//  TemplateTableView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct TemplateTableView: View {
    var body: some View {
        List {
            TemplateTableRow()
            TemplateTableRow()
        }
    }
}

struct TemplateTableView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateTableView()
    }
}
