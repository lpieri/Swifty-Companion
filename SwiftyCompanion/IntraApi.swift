//
//  IntraClass.swift
//  swiftyCompanion
//
//  Created by Louise Pieri on 3/9/20.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import OAuth2

class   IntraApi: OAuth2DataLoader {
    
    let baseUrl: URL = URL(string: "https://api.intra.42.fr/v2/")!
    
    public init() {
        let oauth = OAuth2ClientCredentials(settings: [
            "client_id": "660f2bbbf60c271aa42334a9d5763f32f3309cc76f2d6137623ec77e87cfd8c4",
            "client_secret": "ee01f102baa690eff98507392fc1812ee02126477f63a3eb1e9ffdc43ee64c28",
            "token_uri": "https://api.intra.42.fr/oauth/token",
            "redirect_uris": ["swiftycpieri://oauth/callback"],
            "scope": "public",
            "secret_in_body": true,
            "keychain": false
            ])
        super.init(oauth2: oauth)
    }
    
    func    getToken() {
        let tokenUrl = URL(string: "https://api.intra.42.fr/oauth/token/info")!
        let req = oauth2.request(forURL: tokenUrl)
        perform(request: req) { response in
            do {}
        }
    }
    
    func    request(_ login: String, callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
        /*
        **  Helper for the evaluation
        */
        //  print(oauth2.accessToken)
        let loginUrl = baseUrl.appendingPathComponent("users/\(login)")
        let req = oauth2.request(forURL: loginUrl)
        perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                DispatchQueue.main.async {
                    callback(dict, nil)
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    callback(nil, error)
                }
            }
        }
    }
    
    func    getProfilePicture(_ url: String) -> UIImage? {
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    
    func    parseProjectUser(_ dict: Any) -> [UserData] {
        var projectsParsed = [UserData]()
        let projects = dict as! NSArray
        for projectVal in projects {
            let project = projectVal as! NSDictionary
            let projectCursusIds = project["cursus_ids"] as! NSArray
            let cursusId = projectCursusIds[0] as! NSNumber
            if cursusId.intValue == 1 || cursusId.intValue == 21 {
                let projectData = project["project"] as! NSDictionary
                let projectParent = projectData["parent_id"]
                if projectParent is NSNull {
                    let projectName = projectData["name"] as! String
                    let projectStatus = project["status"] as! String
                    let isValidated = project["validated?"]
                    var projectValidated = false
                    if isValidated is NSNumber {
                        let isVali = isValidated as! NSNumber
                        if isVali.intValue == 1 {
                            projectValidated = true
                        }
                    }
                    if projectStatus == "finished" && project["final_mark"] is NSNumber {
                        let finalMark = project["final_mark"] as! NSNumber
                        let newProject: UserData = UserData(name: projectName, state: projectStatus, grade: finalMark, validated: projectValidated)
                        projectsParsed.append(newProject)
                    } else {
                        let newProject: UserData = UserData(name: projectName, state: projectStatus, grade: NSNumber(0), validated: projectValidated)
                        projectsParsed.append(newProject)
                    }
                }
            }
        }
        return projectsParsed
    }
    
    func    parseSkillsUser(_ dict: Any) -> [UserData] {
        var skillsParsed = [UserData]()
        let skills = dict as! NSArray
        for skillVal in skills {
            let skill = skillVal as! NSDictionary
            let status = "skill"
            let level = skill["level"] as! NSNumber
            let nameSkill = skill["name"] as! String
            let newSkill = UserData(name: nameSkill, state: status, grade: level, validated: false)
            skillsParsed.append(newSkill)
        }
        return skillsParsed
    }
    
    func    createUser(_ json: OAuth2JSON, newUser: User) -> Void {
        let login = json["login"] as! String
        let displayName = json["displayname"] as! String
        let email = json["email"] as! String
        var location: String = "Unavailable"
        if let locationVal = json["location"] {
            if locationVal is String {
                location = locationVal as! String
            }
        }
        let uiImage: UIImage? = getProfilePicture(json["image_url"] as! String)
        let image: Image = Image(uiImage: uiImage!)
        let cursusUsers = json["cursus_users"] as! NSArray
        var level: NSNumber = NSNumber(0)
        var skills: [UserData] = [UserData]()
        for cursus in cursusUsers {
            let dictCursus = cursus as! NSDictionary
            let dictCursusName = dictCursus["cursus"] as! NSDictionary
            if let slugValue = dictCursusName["slug"] {
                let slug: String = slugValue as! String
                if slug == "42" || slug == "42cursus" {
                    let levelAny = dictCursus.value(forKey: "level")
                    let skillsUser = parseSkillsUser(dictCursus.value(forKey: "skills")!)
                    level = levelAny as! NSNumber
                    skills = skillsUser
                }
            }
        }
        let projectsUser = parseProjectUser(json["projects_users"]!)
        newUser.login = login
        newUser.email = email
        newUser.location = location
        newUser.displayName = displayName
        newUser.level = level
        newUser.levelProgress = CGFloat((level.doubleValue - Double(level.intValue)) * 100)
        newUser.image = image
        newUser.projects = projectsUser
        newUser.skills = skills
    }
}
