//
//  Credentials.swift
//  UDConf
//
//  Created by Nikolas Burk on 06/04/17.
//  Copyright © 2017 Nikolas Burk. All rights reserved.
//

import Foundation

let idTokenKey = "idToken"
let userIdKey = "userIdKey"

var currentUserID: String? {
  get {
    return UserDefaults.standard.string(forKey: userIdKey)
  }
  set {
    UserDefaults.standard.set(newValue, forKey: userIdKey)
  }
}

var auth0IdToken: String? {
  get {
    return UserDefaults.standard.string(forKey: idTokenKey)
  }
  set {
    UserDefaults.standard.set(newValue, forKey: idTokenKey)
  }
}
