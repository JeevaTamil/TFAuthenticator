//
//  AccountsView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 21/06/21.
//

import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    @Binding var timeRemaining: Int
    var otps: [OTP]
    var time: Int {
        var components = DateComponents.init()
        components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let second = components.second
        return 30 - (second!%30)
    }
    
    var body: some View {
        ForEach(otps) { otp in
            HStack {
                Image(uiImage: UIImage.init(named: otp.issuer.lowercased()) ?? UIImage(systemName: "shield.fill")!)
                    .resizable()
                    .frame(width: 26, height: 26)
                    .scaledToFit()
        
                VStack(alignment: .leading, spacing: 3) {
                    Text(otp.issuer)
                        .fontWeight(.regular)
                        .font(.body)
                    Text(otp.accName)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(otpViewModel.generateOTPs(otp: otp))
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                    Text(timeRemaining == 0 ? "\(time)" : "\(timeRemaining)")
                        .font(.system(.callout, design: .monospaced))
                        .foregroundColor(timeRemaining < 6 ? .red : .blue)
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    otpViewModel.deleteOTP.send(otp)
                    debugPrint("Deleted")
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                Button {
                    debugPrint("Edit")
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                }.tint(.cyan)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    otpViewModel.starOTP.send(otp)
                    debugPrint("Star")
                } label: {
                    Label("Star", systemImage: !otp.isStared ? "star" : "star.fill")
                }.tint(.yellow)
            }
        }
    }
}
