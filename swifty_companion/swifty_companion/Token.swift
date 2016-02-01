//
//  Token.swift
//  swifty_companion
//
//  Created by Emmanuelle BOEUF on 1/13/16.
//  Copyright © 2016 Emmanuelle BOEUF. All rights reserved.
//

import Foundation
import JSONJoy

var instance : Token?

class Token: JSONJoy {
    
    class var sharedInstance: Token {
        struct Static {
            static var instance: Token? = nil
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Token()
        }
        return Static.instance!
    }
    
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var scope: String?
    var created_at: Int?
    init() {
            
    }
    required init(_ decoder: JSONDecoder) {
        access_token = decoder["access_token"].string
        token_type = decoder["token_type"].string
        expires_in = decoder["expires_in"].integer
        scope = decoder["scope"].string
        created_at = decoder["created_at"].integer
    }
    
    func getAccess() -> String {
        return access_token!
    }
    
    func setAccess(access: String) {
        self.access_token = access
    }
}
