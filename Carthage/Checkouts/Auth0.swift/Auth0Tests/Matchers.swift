// Matchers.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import OHHTTPStubs
import Nimble
@testable import Auth0

func hasAllOf(_ parameters: [String: String]) -> OHHTTPStubsTestBlock {
    return { request in
        guard let payload = request.a0_payload else { return false }
        return parameters.count == payload.count && parameters.reduce(true, { (initial, entry) -> Bool in
            return initial && payload[entry.0] as? String == entry.1
        })
    }
}

func hasAtLeast(_ parameters: [String: String]) -> OHHTTPStubsTestBlock {
    return { request in
        guard let payload = request.a0_payload else { return false }
        let entries = parameters.filter { (key, _) in payload.contains { (name, _) in  key == name } }
        return entries.count == parameters.count && entries.reduce(true, { (initial, entry) -> Bool in
            return initial && payload[entry.0] as? String == entry.1
        })
    }
}

func hasUserMetadata(_ metadata: [String: String]) -> OHHTTPStubsTestBlock {
    return hasObjectAttribute("user_metadata", value: metadata)
}

func hasObjectAttribute(_ name: String, value: [String: String]) -> OHHTTPStubsTestBlock {
    return { request in
        guard let payload = request.a0_payload, let actualValue = payload[name] as? [String: Any] else { return false }
        return value.count == actualValue.count && value.reduce(true, { (initial, entry) -> Bool in
            guard let value = actualValue[entry.0] as? String else { return false }
            return initial && value == entry.1
        })
    }
}

func hasNoneOf(_ names: [String]) -> OHHTTPStubsTestBlock {
    return { request in
        guard let payload = request.a0_payload else { return false }
        return payload.filter { names.contains($0.0) }.isEmpty
    }
}

func hasNoneOf(_ parameters: [String: String]) -> OHHTTPStubsTestBlock {
    return !hasAtLeast(parameters)
}

func hasQueryParameters(_ parameters: [String: String]) -> OHHTTPStubsTestBlock {
    return { request in
        guard
            let url = request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let items = components.queryItems
            else { return false }
        return items.count == parameters.count && items.reduce(true, { (initial, item) -> Bool in
            return initial && parameters[item.name] == item.value
        })
    }
}

func isResourceOwner(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/oauth/ro")
}

func isToken(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/oauth/token")
}

func isSignUp(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/dbconnections/signup")
}

func isResetPassword(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/dbconnections/change_password")
}

func isPasswordless(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/passwordless/start")
}

func isTokenInfo(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/tokeninfo")
}

func isUserInfo(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodGET() && isHost(domain) && isPath("/userinfo")
}

func isOAuthAccessToken(_ domain: String) -> OHHTTPStubsTestBlock {
    return isMethodPOST() && isHost(domain) && isPath("/oauth/access_token")
}

func isUsersPath(_ domain: String, identifier: String? = nil) -> OHHTTPStubsTestBlock {
    let path: String
    if let identifier = identifier {
        path = "/api/v2/users/\(identifier)"
    } else {
        path = "/api/v2/users/"
    }
    return isHost(domain) && isPath(path)
}

func isLinkPath(_ domain: String, identifier: String) -> OHHTTPStubsTestBlock {
    return isHost(domain) && isPath("/api/v2/users/\(identifier)/identities")
}

func hasBearerToken(_ token: String) -> OHHTTPStubsTestBlock {
    return { request in
        return request.value(forHTTPHeaderField: "Authorization") == "Bearer \(token)"
    }
}

func haveAuthenticationError<T>(code: String, description: String) -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "an error response with code <\(code)> and description <\(description)>"
        if let actual = try expression.evaluate(), case .failure(let cause as AuthenticationError) = actual {
            return code == cause.code && description == cause.description
        }
        return false
    }
}

func haveManagementError<T>(_ error: String, description: String, code: String, statusCode: Int) -> MatcherFunc<Result<T>> {
    return beFailure("server error response") { (cause: ManagementError) in
        return error == (cause.info["error"] as? String)
            && code == (cause.info["code"] as? String)
            && description == (cause.info["description"] as? String)
            && statusCode == (cause.info["statusCode"] as? Int)
    }
}

func haveCredentials(_ accessToken: String? = nil, _ idToken: String? = nil) -> MatcherFunc<Result<Credentials>> {
    return MatcherFunc { expression, failureMessage in
        var message = "a successful authentication result"
        if let accessToken = accessToken {
            message = message + " <access_token: \(accessToken)>"
        }
        if let idToken = idToken {
            message = message + " <id_token: \(idToken)>"
        }
        failureMessage.postfixMessage = message
        if let actual = try expression.evaluate(), case .success(let credentials) = actual {
            return (accessToken == nil || credentials.accessToken == accessToken) && (idToken == nil || credentials.idToken == idToken)
        }
        return false
    }
}

func haveCreatedUser(_ email: String, username: String? = nil) -> MatcherFunc<Result<DatabaseUser>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "have created user with email <\(email)>"
        if let actual = try expression.evaluate(), case .success(let created) = actual {
            return created.email == email && (username == nil || created.username == username)
        }
        return false
    }
}

func beSuccessfulResult<T>() -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "be a successful result"
        if let actual = try expression.evaluate(), case .success = actual {
            return true
        }
        return false
    }
}

func beInvalidResponse<T>() -> MatcherFunc<Result<T>> {
    return beFailure("invalid response") { (cause: AuthenticationError) in
        if cause.code == nonJSONError {
            return true
        }
        return false
    }
}

func beSuccessful<T>() -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "be a successful result"
        if let actual = try expression.evaluate(), case .success = actual {
            return true
        }
        return false
    }
}

func beFailure<T>(_ cause: String? = nil) -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        if let cause = cause {
            failureMessage.postfixMessage = "be a failure result with cause \(cause)"
        } else {
            failureMessage.postfixMessage = "be a failure result from auth api"
        }
        if let actual = try expression.evaluate(), case .failure = actual {
            return true
        }
        return false
    }
}

func beFailure<T>(_ cause: String? = nil, predicate: @escaping (AuthenticationError) -> Bool) -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        if let cause = cause {
            failureMessage.postfixMessage = "be a failure result with cause \(cause)"
        } else {
            failureMessage.postfixMessage = "be a failure result from auth api"
        }
        if let actual = try expression.evaluate(), case .failure(let cause as AuthenticationError) = actual {
            return predicate(cause)
        }
        return false
    }
}

func beFailure<T>(_ cause: String? = nil, predicate: @escaping (ManagementError) -> Bool) -> MatcherFunc<Result<T>> {
    return MatcherFunc { expression, failureMessage in
        if let cause = cause {
            failureMessage.postfixMessage = "be a failure result with cause \(cause)"
        } else {
            failureMessage.postfixMessage = "be a failure result from mgmt api"
        }
        if let actual = try expression.evaluate(), case .failure(let cause as ManagementError) = actual {
            return predicate(cause)
        }
        return false
    }
}

func haveProfile(_ userId: String) -> MatcherFunc<Result<Profile>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "have user profile for user id <\(userId)>"
        if let actual = try expression.evaluate(), case .success(let profile) = actual {
            return profile.id == userId
        }
        return false
    }
}

func haveObjectWithAttributes(_ attributes: [String]) -> MatcherFunc<Result<[String: Any]>> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "have attribues \(attributes)"
        if let actual = try expression.evaluate(), case .success(let value) = actual {
            return Array(value.keys).reduce(true, { (initial, value) -> Bool in
                return initial && attributes.contains(value)
            })
        }
        return false
    }
}

func beURLSafeBase64() -> MatcherFunc<String> {
    return MatcherFunc { expression, failureMessage in
        failureMessage.postfixMessage = "be url safe base64"
        var set = CharacterSet()
        set.formUnion(.alphanumerics)
        set.insert(charactersIn: "-_/")
        set.invert()
        if let actual = try expression.evaluate() , actual.rangeOfCharacter(from: set) == nil {
            return true
        }
        return false
    }
}

extension URLRequest {
    var a0_payload: [String: Any]? {
        get {
            return URLProtocol.property(forKey: parameterPropertyKey, in: self) as? [String: Any]
        }
    }
}
