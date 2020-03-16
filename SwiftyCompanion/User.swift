//
//  User.swift
//  swiftyCompanion
//
//  Created by Louise Pieri on 3/10/20.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import Combine
import SwiftUI

struct  Project {
    
    var projectName: String
    var projectState: String
    var projectGrade: NSNumber
    var projectValidated: Bool
    
}

class   User: ObservableObject {
    
    let didChange = PassthroughSubject<Void, Never>()
    
    var login: String = "default" { didSet { didChange.send() } }
    var email: String = "default@student.42.fr" { didSet { didChange.send() } }
    var location: String = "Unavailable" { didSet { didChange.send() } }
    var displayName: String = "Default Name" { didSet { didChange.send() } }
    var level: NSNumber = NSNumber(value: 0) { didSet { didChange.send() } }
    var image: Image = Image("pp") { didSet { didChange.send() } }
    var projects: [Project] = [Project]() { didSet { didChange.send() } }
    
}
