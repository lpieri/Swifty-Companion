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
    
    func    parseProjectUser(_ dict: Any, _ cursus42: Bool) -> [UserData] {
        var projectsParsed = [UserData]()
        var i: Int = 0
        let projects = dict as! NSArray
        let searchProjectCursus = (cursus42 == true) ? 21 : 1
        for projectVal in projects {
            let project = projectVal as! NSDictionary
            let projectCursusIds = project["cursus_ids"] as! NSArray
            if projectCursusIds.count == 0 {
                continue
            }
            let cursusId = projectCursusIds[0] as! NSNumber
            if cursusId.intValue == searchProjectCursus {
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
                        let newProject: UserData = UserData(id: i, name: projectName, state: projectStatus, grade: finalMark, validated: projectValidated)
                        projectsParsed.append(newProject)
                        i += 1
                    } else {
                        let newProject: UserData = UserData(id: i, name: projectName, state: projectStatus, grade: NSNumber(0), validated: projectValidated)
                        projectsParsed.append(newProject)
                        i += 1
                    }
                }
            }
        }
        return projectsParsed
    }
    
    func    parseSkillsUser(_ dict: Any) -> [UserData] {
        var skillsParsed = [UserData]()
        var i: Int = 0
        let skills = dict as! NSArray
        for skillVal in skills {
            let skill = skillVal as! NSDictionary
            let status = "skill"
            let level = skill["level"] as! NSNumber
            let nameSkill = skill["name"] as! String
            let newSkill = UserData(id: i, name: nameSkill, state: status, grade: level, validated: false)
            skillsParsed.append(newSkill)
            i += 1
        }
        return skillsParsed
    }
    
    func    createUser(_ json: OAuth2JSON, newUser: User) -> Void {
        var primaryCursus: Bool = false
        var location: String = "Unavailable"
        var levelAny: Any?
        var skillsUser = [UserData]()
        let uiImage: UIImage? = getProfilePicture(json["image_url"] as! String)
        let cursusUsers = json["cursus_users"] as! NSArray
        if let locationVal = json["location"] {
            if locationVal is String {
                location = locationVal as! String
            }
        }
        for cursus in cursusUsers {
            let dictCursus = cursus as! NSDictionary
            let dictCursusName = dictCursus["cursus"] as! NSDictionary
            if let slugValue = dictCursusName["slug"] {
                let slug: String = slugValue as! String
                if (slug == "42" || slug == "42cursus") && primaryCursus == false {
                    if slug == "42cursus" {
                        primaryCursus = true
                    }
                    levelAny = dictCursus.value(forKey: "level")!
                    skillsUser = parseSkillsUser(dictCursus.value(forKey: "skills")!)
                }
            }
        }
        newUser.login = json["login"] as! String
        newUser.displayName = json["displayname"] as! String
        newUser.email = json["email"] as! String
        newUser.image = Image(uiImage: uiImage!)
        newUser.location = location
        newUser.level = levelAny! as! NSNumber
        newUser.levelProgress = CGFloat((newUser.level.doubleValue - Double(newUser.level.intValue)) * 100)
        newUser.skills = skillsUser
        newUser.projects = parseProjectUser(json["projects_users"]!, primaryCursus)
    }
}
