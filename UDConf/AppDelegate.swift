//
//  AppDelegate.swift
//  UDConf
//
//  Created by Nikolas Burk on 06/04/17.
//  Copyright © 2017 Nikolas Burk. All rights reserved.
//

import UIKit
import Apollo
import Lock

let graphQLEndpoint = "https://api.graph.cool/simple/v1/__PROJECT_ID__"

var apollo: ApolloClient!

func initializeApollo(idToken: String) {
  let configuration = URLSessionConfiguration.default
  configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(idToken)"]
  apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: URL(string: graphQLEndpoint)!, configuration: configuration))
  apollo.cacheKeyForObject = { $0["id"] }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    if let idToken = auth0IdToken {
      initializeApollo(idToken: idToken)
    }
    
    return true
  }
  
  
}

