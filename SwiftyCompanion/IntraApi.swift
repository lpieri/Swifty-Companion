//
//  IntraClass.swift
//  swiftyCompanion
//
//  Created by Louise Pieri on 3/9/20.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//
import UIKit
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
    
    func    request(_ login: String, callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
        oauth2.logger = OAuth2DebugLogger(.debug)
        let loginUrl = baseUrl.appendingPathComponent("users/\(login)")
        let req = oauth2.request(forURL: loginUrl)
        perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                DispatchQueue.main.async {
                    print(dict)
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
    
    func    parseProjectUser(_ dict: Any) -> [Any] {
        var projectsParsed = [Any]()
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
                    if projectStatus == "finished" {
                        let finalMark = project["final_mark"] as! NSNumber
                        let newProject: [String:Any] = [projectName:finalMark]
                        projectsParsed.append(newProject)
                    } else {
                        let newProject: [String:Any] = [projectName:projectStatus]
                        projectsParsed.append(newProject)
                    }
                }
            }
        }
        return projectsParsed
    }
    
    func    createUser(_ json: OAuth2JSON) -> User? {
        let login = json["login"] as! String
        let displayName = json["displayname"] as! String
        let email = json["email"] as! String
        var location: String = "Unavailable"
        if let locationVal = json["location"] {
            if locationVal is String {
                location = locationVal as! String
            }
        }
        let image: UIImage? = getProfilePicture(json["image_url"] as! String)
        let cursusUsers = json["cursus_users"] as! NSArray
        var level: NSNumber = NSNumber(0)
        for cursus in cursusUsers {
            let dictCursus = cursus as! NSDictionary
            let dictCursusName = dictCursus["cursus"] as! NSDictionary
            if let slugValue = dictCursusName["slug"] {
                let slug: String = slugValue as! String
                if slug == "42" || slug == "42cursus" {
                    let levelAny = dictCursus.value(forKey: "level")
                    level = levelAny as! NSNumber
                }
            }
        }
        let projectsUser = parseProjectUser(json["projects_users"]!)
        let newUser = User(login: login, displayName: displayName, email: email, location: location, level: level, image: image, projects: projectsUser)
        return newUser
    }
}
