//
//  User.swift
//  swifty_companion
//
//  Created by Emmanuelle BOEUF on 1/14/16.
//  Copyright © 2016 Emmanuelle BOEUF. All rights reserved.
//

import Foundation
import JSONJoy

struct Skills {
    var nameSkill: String?
    var percentSkill: Float?
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        nameSkill = decoder["name"].string
        percentSkill = decoder["level"].float
    }
}

struct Projects {
    var slug: String?
    var final_mark: Int?
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        slug = decoder["slug"].string
        final_mark = decoder["final_mark"].integer
    }
}

class User: JSONJoy {
    
    var email: String?
    var login: String?
    var phone: String?
    var image_url: String?
    var displayname: String?
    var slug: String?
    var final_mark: Int?
    var nameSkill: String?
    var percentSkill: Float?
    var level: Float?
    var projects: Array<Projects>?
    var skills : Array<Skills>?
    init() {
        
    }
    required init(_ decoder: JSONDecoder) {
        email = decoder["email"].string
        login = decoder["login"].string
        phone = decoder["phone"].string
        image_url = decoder["image_url"].string
        displayname = decoder["displayname"].string
        
        if let cur = decoder["cursus"].array {
            for decoder in cur {
                level = decoder["level"].float
                
                let pjt = decoder["projects"].array
                projects = Array<Projects>()
                for subDecoder in pjt! {
                    projects!.append(Projects(subDecoder))
                    slug = decoder["slug"].string
                    final_mark = decoder["final_mark"].integer
                }
                
                let sk = decoder["skills"].array
                skills = Array<Skills>()
                for subDecoder in sk! {
                    skills!.append(Skills(subDecoder))
                    nameSkill = decoder["name"].string
                    percentSkill = decoder["level"].float
                }
            }
        }
    }
}
