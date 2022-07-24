//
//  Errors.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

/// Errors that occured accessing BoxCast API resources.
public enum BoxCastError: Error {
    /// The request could not be understood due to malformed syntax.
    case badRequest
    /// The request requires user authentication.
    case unauthorized
    /// The access token provided is expired, revoked, malformed or invalid for other reasons.
    case invalidToken
    /// Payment is required to complete the request.
    case paymentRequired
    /// The request is forbidden.
    case forbidden
    /// The requested resource was not found.
    case notFound
    /// The request could not be completed due to a conflict with the current state of the resource.
    case conflict
    /// The requested resource is no longer available.
    case gone
    /// The request could not be processed.
    case unprocessableEntity
    /// The user has sent too many requests in a given amount of time.
    case tooManyRequests
    /// The server encountered an unexpected condition which prevented it from fulfilling the
    /// request.
    case internalServerError
    /// The server does not support the functionality required to fulfill the request.
    case notImplemented
    /// The server, while acting as a gateway or proxy, received an invalid response from the
    /// upstream server it accessed in attempting to fulfill the request.
    case badGateway
    /// The server is currently unable to handle the request due to a temporary overloading or
    /// maintenance of the server.
    case serviceUnavailable
    /// The server, while acting as a gateway or proxy, did not receive a timely response from the
    /// upstream server specified by the URI (e.g. HTTP, FTP, LDAP) or some other auxiliary server
    /// (e.g. DNS) it needed to access in attempting to complete the request.
    case gatewayTimeout
    /// The request is missing a required parameter, includes an unsupported parameter value, or is
    /// otherwise malformed.
    case invalidRequest
    /// Client authentication failed (e.g., unknown client, no client authentication included, or
    /// unsupported authentication method).
    case invalidClient
    /// The provided authorization grant is invalid, expired or revoked.
    case invalidGrant
    /// The authenticated client is not authorized to use this authorization grant type.
    case unauthorizedClient
    /// The authorization grant type is not supported by the authorization server.
    case unsupportedGrantType
    /// Object serialization error.
    case objectSerialization
    /// The resource was unable to be serialized.
    case serializationError
    /// The URL provided was invalid.
    case invalidURL
    /// Unknown error.
    case unknown
}

extension BoxCastError {
    public init?(responseData: Data) {
        guard let dict = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else {
            return nil
        }
        guard let error = dict["error"] as? String else {
                return nil
        }
        switch error {
        case "bad_request":
            self = .badRequest
        case "unauthorized":
            self = .unauthorized
        case "invalid_token":
            self = .invalidToken
        case "payment_required":
            self = .paymentRequired
        case "forbidden":
            self = .forbidden
        case "not_found":
            self = .notFound
        case "conflict":
            self = .conflict
        case "gone":
            self = .gone
        case "unprocessable_entity":
            self = .unprocessableEntity
        case "too_many_requests":
            self = .tooManyRequests
        case "internal_server_error":
            self = .internalServerError
        case "not_implemented":
            self = .notImplemented
        case "bad_gateway":
            self = .badGateway
        case "service_unavailable":
            self = .serviceUnavailable
        case "gateway_timeout":
            self = .gatewayTimeout
        case "invalid_request":
            self = .invalidRequest
        case "invalid_client":
            self = .invalidClient
        case "invalid_grant":
            self = .invalidGrant
        case "unauthorized_client":
            self = .unauthorizedClient
        case "unsupported_grant_type":
            self = .unsupportedGrantType
        default:
            self = .unknown
        }
    }
}
