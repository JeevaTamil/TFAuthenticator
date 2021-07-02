//
//  TFAListWrapperView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 02/07/21.
//

import SwiftUI

struct TFAListWrapperView: View {
    @Binding var timeRemaining: Int
    @Binding var isToastPresented: Bool
    var otps: [OTP]
    
    var body: some View {
        if otps.isEmpty {
            Text("No results found!")
        }
        if otps.filter({$0.isStared}).count != 0 {
            Section(header: Text("Stared")) {
                AccountsView(timeRemaining: $timeRemaining, isToastPresented: $isToastPresented, otps: otps.filter({$0.isStared}))
            }
        }
        if otps.filter({!$0.isStared}).count != 0 {
            Section(header: Text("Accounts")) {
                AccountsView(timeRemaining: $timeRemaining, isToastPresented: $isToastPresented, otps: otps.filter({!$0.isStared}))
            }
        }
    }
}
