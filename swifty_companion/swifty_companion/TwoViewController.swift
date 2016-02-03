//
//  TwoViewController.swift
//  swifty_companion
//
//  Created by Emmanuelle BOEUF on 1/8/16.
//  Copyright © 2016 Emmanuelle BOEUF. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class TwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token = Token.sharedInstance
    var toUser: User!
    var toAccess: String!
    
    @IBOutlet weak var go_back: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var displayname: UILabel!
    
    @IBOutlet weak var projectsTable: UITableView!
    @IBOutlet weak var skillsTable: UITableView!
    
    // MARK: - Init Element
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        self.go_back.layer.cornerRadius = 5
        
        self.login.text = "\(toUser.login!)"
        self.mail.text = "\(toUser.email!)"
        self.phone.text = "\(toUser.phone!)"
        
        let lev = String(toUser.level!).componentsSeparatedByString(".")
        self.level.text = "Level: \(lev[0]) - \(lev[1])%"
        
        self.displayname.text = "\(toUser.displayname!)"
        
        if let url = NSURL(string: "\(toUser.image_url!)") {
            if let data = NSData(contentsOfURL: url) {
                image.image = UIImage(data: data)
            }
        }
        
        token.setAccess(toAccess)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == projectsTable {
            return (toUser.projects?.count)!
        } else {
            return (toUser.skills?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == projectsTable {
            let cell = projectsTable.dequeueReusableCellWithIdentifier("projectsCell", forIndexPath: indexPath) as! SCTableViewCell
            
            let sortProject = toUser.projects!.sort{ $0.slug < $1.slug }
            cell.nameProjects?.text = sortProject[indexPath.row].slug
            if sortProject[indexPath.row].final_mark == nil {
                cell.finalMark?.text = "Loading"
            }else if sortProject[indexPath.row].final_mark < 50 {
                cell.finalMark?.text = ("\(sortProject[indexPath.row].final_mark!)% - FAILED")
            } else {
                cell.finalMark?.text = ("\(sortProject[indexPath.row].final_mark!)% - SUCCEEDED")
            }
            return cell
        } else {
            let cell = skillsTable.dequeueReusableCellWithIdentifier("skillsCell", forIndexPath: indexPath) as! SCTableViewCell
            
            let sortSkill = toUser.skills!.sort{ $0.nameSkill < $1.nameSkill }
            let ns = sortSkill[indexPath.row].nameSkill
            let ps = String(sortSkill[indexPath.row].percentSkill!)
            
            cell.nameSkills?.text = ns
            
            let spl = ps.componentsSeparatedByString(".")
            let fl = (spl[1] as NSString).floatValue
            cell.progressSkills.progress = fl / 100
            
            cell.levelPercent?.text = ("Level: \(spl[0]) - \(spl[1])%")
            
            return cell
        }
    }
}
