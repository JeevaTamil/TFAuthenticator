//
//  Constants.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation

public struct Constants {
    static let group: String = "group.com.jeeva.TFAuthenticator"
    
    struct keys {
        static let kOTParray = "kOTParray"
        static let kRecentlyDeletedOTParray = "kRecentlyDeletedOTParray"
    }
}

public struct kFormFields {
    static let basicOptionsTitle = "basic options"
    static let issuerFieldName = "Issuer"
    static let issuerPlaceholder = "ex: Google"
    static let accNameFieldName = "Account"
    static let accNamePlaceholder = "ex: user@gmail.com"
    static let tokenFieldName = "Token"
    static let tokenPlaceholder = "ASDFGHJKL..."
    static let backupCodeTitle = "backup codes (optional)"
    static let backupCodePlaceholder =
    """
    ex:
    1. QEWR WERT WERT
    2. NNVG EETF ZCSS
    3. WERT WYURT SDFG
    4. GEHF ZCSS JBJM
    """
    static let extensionTitle = "Use in"
    
}
