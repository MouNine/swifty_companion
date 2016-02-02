//
//  ViewController.swift
//  swifty_companion
//
//  Created by Emmanuelle BOEUF on 1/5/16.
//  Copyright © 2016 Emmanuelle BOEUF. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class ViewController: UIViewController {
    
    var token = Token.sharedInstance
    var user: User!
    var boo = true
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var search: UIButton!

    // MARK: - Init Elements
    
   override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    
        self.login.layer.cornerRadius = 5
        self.search.layer.cornerRadius = 5
        self.login.layer.borderWidth = 1
        self.login.layer.borderColor = UIColor(red:0/255.0, green:186/255.0, blue:188/255.0, alpha: 1.0).CGColor
        self.login.attributedPlaceholder = NSAttributedString(string: "Login",
            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    
        if (token.access_token == nil) {
            post();
        }
    
    print("ViewLoad: \(self.boo)");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func search(sender: AnyObject) {
        get()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentAlert()
        })
    }
    
    func presentAlert() {
        if (login.text == "") {
            self.boo = true
            let alertController = UIAlertController(title: "Error", message: "Textfield is empty", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else if (self.boo == false) {
            self.boo = true
            let alertController = UIAlertController(title: "Error", message: "Login doesn't exist", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Request POST
    
    func post()
    {
        let params = ["grant_type": "client_credentials", "client_id": "4fcfc213470d53a20d26216890c8c9a370a923bfc145b0c826a0d281b0a2833b", "client_secret": "df83e266d380746805db562ae018bc6b405dc379035e3ad03aa3f3f51608284e"]
        do {
            let opt = try HTTP.POST("https://api.intra.42.fr/oauth/token", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }
                print("opt finished: \(response.description)")
                self.token = Token(JSONDecoder(response.data))
                if let access_token = self.token.access_token {
                    print("completed: \(access_token)")
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    // MARK: - Request GET
    func get()
    {
        do {
            let opt = try HTTP.GET("https://api.intra.42.fr/v2/users/\(self.login!.text!)?access_token=\(self.token.access_token!)")
            opt.start { response in
                if let err = response.error {
                    self.boo = false
                    print("error: \(err.localizedDescription)")
                    return
                }
                self.user = User(JSONDecoder(response.data))
                print("opt finished: \(response.description)")
                let loginSuccessful: Bool = true
                if loginSuccessful {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.performSegueWithIdentifier("SegueToSecond", sender: self.search)
                    }
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SegueToSecond") {
            let svc = segue.destinationViewController as! TwoViewController;
            svc.toUser = self.user!
            svc.toAccess = self.token.getAccess()
        }
    }
}