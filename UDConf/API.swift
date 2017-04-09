//  This file was automatically generated and should not be edited.

import Apollo

public final class ConferenceAttendeesQuery: GraphQLQuery {
  public static let operationDefinition =
    "query ConferenceAttendees($id: ID!) {" +
    "  Conference(id: $id) {" +
    "    __typename" +
    "    id" +
    "    attendees {" +
    "      __typename" +
    "      ...AttendeeDetails" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(AttendeeDetails.fragmentDefinition)

  public let id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLMappable {
    public let conference: Conference?

    public init(reader: GraphQLResultReader) throws {
      conference = try reader.optionalValue(for: Field(responseName: "Conference", arguments: ["id": reader.variables["id"]]))
    }

    public struct Conference: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID
      public let attendees: [Attendee]?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
        attendees = try reader.optionalList(for: Field(responseName: "attendees"))
      }

      public struct Attendee: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let attendeeDetails = try AttendeeDetails(reader: reader)
          fragments = Fragments(attendeeDetails: attendeeDetails)
        }

        public struct Fragments {
          public let attendeeDetails: AttendeeDetails
        }
      }
    }
  }
}

public final class AttendConferenceMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation AttendConference($userId: ID!, $conferenceId: ID!) {" +
    "  addToConferenceAttendees(attendeesUserId: $userId, conferencesConferenceId: $conferenceId) {" +
    "    __typename" +
    "    conferencesConference {" +
    "      __typename" +
    "      id" +
    "      attendees {" +
    "        __typename" +
    "        ...AttendeeDetails" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(AttendeeDetails.fragmentDefinition)

  public let userId: GraphQLID
  public let conferenceId: GraphQLID

  public init(userId: GraphQLID, conferenceId: GraphQLID) {
    self.userId = userId
    self.conferenceId = conferenceId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "conferenceId": conferenceId]
  }

  public struct Data: GraphQLMappable {
    public let addToConferenceAttendees: AddToConferenceAttendee?

    public init(reader: GraphQLResultReader) throws {
      addToConferenceAttendees = try reader.optionalValue(for: Field(responseName: "addToConferenceAttendees", arguments: ["attendeesUserId": reader.variables["userId"], "conferencesConferenceId": reader.variables["conferenceId"]]))
    }

    public struct AddToConferenceAttendee: GraphQLMappable {
      public let __typename: String
      public let conferencesConference: ConferencesConference?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        conferencesConference = try reader.optionalValue(for: Field(responseName: "conferencesConference"))
      }

      public struct ConferencesConference: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let attendees: [Attendee]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          attendees = try reader.optionalList(for: Field(responseName: "attendees"))
        }

        public struct Attendee: GraphQLMappable {
          public let __typename: String

          public let fragments: Fragments

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))

            let attendeeDetails = try AttendeeDetails(reader: reader)
            fragments = Fragments(attendeeDetails: attendeeDetails)
          }

          public struct Fragments {
            public let attendeeDetails: AttendeeDetails
          }
        }
      }
    }
  }
}

public final class NotAttendConferenceMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation NotAttendConference($userId: ID!, $conferenceId: ID!) {" +
    "  removeFromConferenceAttendees(attendeesUserId: $userId, conferencesConferenceId: $conferenceId) {" +
    "    __typename" +
    "    conferencesConference {" +
    "      __typename" +
    "      id" +
    "      attendees {" +
    "        __typename" +
    "        ...AttendeeDetails" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(AttendeeDetails.fragmentDefinition)

  public let userId: GraphQLID
  public let conferenceId: GraphQLID

  public init(userId: GraphQLID, conferenceId: GraphQLID) {
    self.userId = userId
    self.conferenceId = conferenceId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "conferenceId": conferenceId]
  }

  public struct Data: GraphQLMappable {
    public let removeFromConferenceAttendees: RemoveFromConferenceAttendee?

    public init(reader: GraphQLResultReader) throws {
      removeFromConferenceAttendees = try reader.optionalValue(for: Field(responseName: "removeFromConferenceAttendees", arguments: ["attendeesUserId": reader.variables["userId"], "conferencesConferenceId": reader.variables["conferenceId"]]))
    }

    public struct RemoveFromConferenceAttendee: GraphQLMappable {
      public let __typename: String
      public let conferencesConference: ConferencesConference?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        conferencesConference = try reader.optionalValue(for: Field(responseName: "conferencesConference"))
      }

      public struct ConferencesConference: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let attendees: [Attendee]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          attendees = try reader.optionalList(for: Field(responseName: "attendees"))
        }

        public struct Attendee: GraphQLMappable {
          public let __typename: String

          public let fragments: Fragments

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))

            let attendeeDetails = try AttendeeDetails(reader: reader)
            fragments = Fragments(attendeeDetails: attendeeDetails)
          }

          public struct Fragments {
            public let attendeeDetails: AttendeeDetails
          }
        }
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateUser($name: String!, $idToken: String!) {" +
    "  createUser(name: $name, authProvider: {auth0: {idToken: $idToken}}) {" +
    "    __typename" +
    "    id" +
    "    name" +
    "  }" +
    "}"

  public let name: String
  public let idToken: String

  public init(name: String, idToken: String) {
    self.name = name
    self.idToken = idToken
  }

  public var variables: GraphQLMap? {
    return ["name": name, "idToken": idToken]
  }

  public struct Data: GraphQLMappable {
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["name": reader.variables["name"], "authProvider": ["auth0": ["idToken": reader.variables["idToken"]]]]))
    }

    public struct CreateUser: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID
      public let name: String

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
        name = try reader.value(for: Field(responseName: "name"))
      }
    }
  }
}

public final class AllConferencesQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllConferences {" +
    "  allConferences {" +
    "    __typename" +
    "    ...ConferenceDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(ConferenceDetails.fragmentDefinition)
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let allConferences: [AllConference]

    public init(reader: GraphQLResultReader) throws {
      allConferences = try reader.list(for: Field(responseName: "allConferences"))
    }

    public struct AllConference: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let conferenceDetails = try ConferenceDetails(reader: reader)
        fragments = Fragments(conferenceDetails: conferenceDetails)
      }

      public struct Fragments {
        public let conferenceDetails: ConferenceDetails
      }
    }
  }
}

public struct AttendeeDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment AttendeeDetails on User {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  _conferencesMeta {" +
    "    __typename" +
    "    count" +
    "  }" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let conferencesMeta: ConferencesMetum

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    conferencesMeta = try reader.value(for: Field(responseName: "_conferencesMeta"))
  }

  public struct ConferencesMetum: GraphQLMappable {
    public let __typename: String
    public let count: Int

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      count = try reader.value(for: Field(responseName: "count"))
    }
  }
}

public struct ConferenceDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment ConferenceDetails on Conference {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  city" +
    "  year" +
    "  attendees {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public static let possibleTypes = ["Conference"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let city: String
  public let year: String
  public let attendees: [Attendee]?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    city = try reader.value(for: Field(responseName: "city"))
    year = try reader.value(for: Field(responseName: "year"))
    attendees = try reader.optionalList(for: Field(responseName: "attendees"))
  }

  public struct Attendee: GraphQLMappable {
    public let __typename: String
    public let id: GraphQLID

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      id = try reader.value(for: Field(responseName: "id"))
    }
  }
}