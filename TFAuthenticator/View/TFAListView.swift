//
//  TFAListView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import SwiftUI

struct TFAListView: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    var body: some View {
        List {
            ForEach(otpViewModel.otps.value) { otp in
                Text(otp.issuer)
            }
        }
        .navigationBarTitle("Authenticator")
    }
}

struct TFAListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
