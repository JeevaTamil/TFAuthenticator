//
//  ModelView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 21/06/21.
//

import SwiftUI

enum ModelView: Identifiable, View {
    case scanQR
    case manual
    case update(OTP)
    case settings
    
    var id: String {
        switch self {
        case .scanQR:
            return "scanQR"
        case .manual:
            return "manual"
        case .update(_):
            return "update"
        case .settings:
            return "Settings"
        }
    }
    
    var body: some View {
        NavigationView {
            switch self {
            case .scanQR:
                TFAScanQView()
            case .manual:
                TFAManualFormView(formVM: OTPFormViewModel())
            case .update(let otp):
                TFAManualFormView(formVM: OTPFormViewModel(otp))
            case .settings:
                SettingsView()
            }
        }
    }
}
