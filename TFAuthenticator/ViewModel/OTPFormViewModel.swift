//
//  OTPViewModel.swift
//  Widget Auth
//
//  Created by Azhagusundaram Tamil on 26/10/20.
//

import Foundation

class OTPFormViewModel: ObservableObject {
    @Published var issuer = ""
    @Published var accName = ""
    @Published var token = ""
    @Published var isWidgetAllowed = true
    @Published var isWatchAllowed = false
    @Published var backupCodes = ""
    
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        issuer.isEmpty
    }
    
    init() {
        
    }
    
    init(_ currentOTP: OTP) {
        issuer = currentOTP.issuer
        accName = currentOTP.accName
        token = currentOTP.id
        id = currentOTP.id
        isWidgetAllowed = currentOTP.isWidgetAllowed
        isWatchAllowed = currentOTP.isWatchAllowed
        backupCodes = currentOTP.backupCodes
    }
}
