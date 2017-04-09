//
//  ConferencesTableViewController.swift
//  UDConf
//
//  Created by Nikolas Burk on 06/04/17.
//  Copyright © 2017 Nikolas Burk. All rights reserved.
//

import UIKit
import Lock
import Apollo

class ConferencesTableViewController: UITableViewController {
  
  var conferences: [ConferenceDetails] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  var conferencesWatcher: GraphQLQueryWatcher<AllConferencesQuery>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Conferences"
    
    if currentUserID == nil {
      initiateAuth0Login()
    } else {
      queryConferences()
    }
  }

  
  // MARK: API

  func queryConferences() {
    let allConferencesQuery = AllConferencesQuery()
    conferencesWatcher = apollo.watch(query: allConferencesQuery) { result, error in
      guard let conferences = result?.data?.allConferences else { return }
      self.conferences = conferences.map { $0.fragments.conferenceDetails }
    }
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conferences.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let conference = conferences[indexPath.row]
    cell.textLabel?.text = conference.name
    cell.detailTextLabel?.text = "\(conference.attendees?.count ?? 0) attendees"
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let selectedConference = conferences[tableView.indexPathForSelectedRow!.row]
    let conferencesDetailViewController = segue.destination as! ConferencesDetailViewController
    conferencesDetailViewController.conference = selectedConference
  }
  
  
  // MARK: Authentication
  
  func initiateAuth0Login() {
    Lock
      .classic()
      .withStyle {
        $0.title = "Conference Planner"
      }
      .onAuth { credentials in
        print("ID Token: \(credentials.idToken)")
        print("Access Token: \(credentials.accessToken)")
        if let idToken = credentials.idToken {
          self.handleSuccessfulLogin(idToken: idToken)
        }
      }
      .onError {
        print("Failed with \($0)")
      }
      .present(from: self)
  }
  
  func handleSuccessfulLogin(idToken: String) {
    auth0IdToken = idToken
    initializeApollo(idToken: idToken)
    let createUserMutation = CreateUserMutation(name: "Nikolas", idToken: idToken)
    apollo.perform(mutation: createUserMutation) { result, error in
      currentUserID = result?.data?.createUser?.id
      self.queryConferences()
    }
  }

}
