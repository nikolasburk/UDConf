//
//  ConferencesDetailViewController.swift
//  UDConf
//
//  Created by Nikolas Burk on 06/04/17.
//  Copyright © 2017 Nikolas Burk. All rights reserved.
//

import UIKit
import Apollo

class ConferencesDetailViewController: UIViewController {
  
  @IBOutlet weak var conferenceTitleLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var attendeesTableView: UITableView!
  @IBOutlet weak var attendingStatusButton: UIButton!

  var conferenceAttendeesWatcher: GraphQLQueryWatcher<ConferenceAttendeesQuery>!
  
  var conference: ConferenceDetails!
  var attendees: [AttendeeDetails] = [] {
    didSet {
      updateUI()
    }
  }
  
  var currentUserIsAttending: Bool {
    get {
      return attendees.contains(where: { $0.id == currentUserID! })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Details"
    conferenceTitleLabel.text = "\(conference.name) \(conference.year)"
    cityLabel.text = conference.city
    
    loadData()
    if isViewLoaded {
      updateUI()
    }
  }
  

  // MARK: API Interaction
  
  func loadData() {
    
    let conferenceAttendeesQuery = ConferenceAttendeesQuery(id: conference.id)
    conferenceAttendeesWatcher = apollo.watch(query: conferenceAttendeesQuery) { result, error in
      guard let conference = result?.data?.conference else { return }
      self.attendees = conference.attendees!.map { $0.fragments.attendeeDetails }
    }
    
  }
  
  func attendConference() {
    let attendConferenceMutation = AttendConferenceMutation(userId: currentUserID!, conferenceId: conference.id)
    apollo.perform(mutation: attendConferenceMutation, resultHandler: nil)
  }
  
  func notAttendConference() {
    let notAttendConferenceMutation = NotAttendConferenceMutation(userId: currentUserID!, conferenceId: conference.id)
    apollo.perform(mutation: notAttendConferenceMutation, resultHandler: nil)
  }
  
  @IBAction func attendingStatusButtonPressed() {
    if currentUserIsAttending {
      notAttendConference()
    } else {
      attendConference()
    }
  }
  
  
  // MARK: Helpers
  
  func updateUI() {
    let attendingStatusButtonTitle = currentUserIsAttending ? "Don't attend 😌" : "Attend 🙋"
    attendingStatusButton.setTitle(attendingStatusButtonTitle, for: .normal)
    attendeesTableView.reloadData()
  }
  
}


// MARK: UITableViewDataSource

extension ConferencesDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return attendees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    let attendee = attendees[indexPath.row]
    cell.textLabel?.text = attendee.name
    cell.detailTextLabel?.text = "attends \(attendee.conferencesMeta.count - 1) other conferences"

    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Attendees"
  }
  
}
