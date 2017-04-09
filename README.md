# UDConf - Conference Planner

This project demonstrates how to use a GraphQL API with Apollo in an iOS app. 

Our sample app is a _Conference Planner_ that allows people to manage what conferences they'd like to attend and see a list of all other attendees.

## Getting a GraphQL server

We'll use the Graphcool CLI to generate a GraphQL server:

```bash
npm install -g graphcool
graphcool init https://raw.githubusercontent.com/graphcool-examples/schemas/master/udconf.schema -n "ConferencePlanner"
```

Copy the endpoint for the `Simple API` and save it for later usage!

As a reference, this is what our [data model](https://raw.githubusercontent.com/graphcool-examples/schemas/master/udconf.schema) looks like:

```graphql
type Conference {
  id: ID!
  name: String!
  city: String!
  year: String!
  attendees: [Attendee] @relation(name: "ConferenceAttendees")
}

type Attendee {
  id: ID!
  name: String!
  conferences: [Conference] @relation(name: "ConferenceAttendees")
}
```

## Apollo Setup

The Xcode project is already fully configured for using Apollo:

1. Static type generation is configured in a _build phase_ called `Generate Apollo GraphQL API` that is invoked right before compilation
2. `schema.json` is available in the root directory of the project
3. The `ApolloClient` is instantiated in `AppDelegate.swift` and will use the _Auth0 ID Token_ to authenticate its requests

The only thing that's left do to for you is to add the endpoint for the `Simple API` from the previous step to `AppDelegate.swift` where you set it as a value for the `graphQLEndpoint`:

```swift
let graphQLEndpoint = "https://api.graph.cool/simple/v1/__PROJECT_ID__"
```

## Auth0 Setup

Before viewing the conferences, a user must log in. We're using [Auth0](https://auth0.com/) to implement authentication. 

In order for you to use Auth0 in this sample app, you'll have to create your own Auth0 project and copy over the project's **Client Id** and **Domain** into `Auth0.plist`.

Next, you'll also have to put the **Client Id**, **Domain** and **Client Secret** when configuring the [Auth0 Integration](https://www.graph.cool/docs/reference/platform/integrations/auth0-naed3eecie/) in the [Graphcool console](https://console.graph.cool). 

## Happy Hacking 

That's it, have fun exploring GraphQL! 🚀
