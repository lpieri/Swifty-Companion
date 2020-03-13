//
//  User.swift
//  swiftyCompanion
//
//  Created by Louise Pieri on 3/10/20.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//
import SwiftUI

class   User {
    
    var login: String
    var email: String
    var location: String
    var displayName: String
    var level: NSNumber
    var image: Image
    var projects: [Any]
    
    init?(login: String, displayName: String, email: String, location: String, level: NSNumber, image: Image, projects: [Any]) {
        if login.isEmpty || email.isEmpty || location.isEmpty || level.doubleValue < 0 {
            return nil
        }
        self.login = login
        self.displayName = displayName
        self.email = email
        self.location = location
        self.level = level
        self.image = image
        self.projects = projects
    }
    
}
