//
//  Errors.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation

enum TFAError: Error {
    case invalidSecret
    case invalidEncoding
    case unwrappingFailed
    case keychainError(error: String)
    case unableToCreateOTPObj
    
    var description: String {
        switch self {
        case .invalidSecret:
            return "Secret in not valid"
        case .invalidEncoding:
            return "Encoding is not valid"
        case .unwrappingFailed:
            return "nil value when unwrapping"
        case .keychainError(let error):
            return error
        case .unableToCreateOTPObj:
            return "OTP Object is null when creating"
        }
    }
}
