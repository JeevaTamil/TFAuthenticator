//
//  TFARecentlyDeletedView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 02/07/21.
//

import SwiftUI

struct TFARecentlyDeletedView: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    
    var body: some View {
        List {
            ForEach(otpViewModel.recentlyDeleted.value) { otp in
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
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive) {
                        otpViewModel.deleteRecentOTP.send(otp)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        otpViewModel.restoreOTP.send(otp)
                    } label: {
                        Label("Return", systemImage: "arrow.uturn.left")
                    }.tint(.cyan)
                })
            }
        }
        
        .navigationBarTitle("Recently Deleted")
    }
}

struct TFARecentlyDeletedView_Previews: PreviewProvider {
    static var previews: some View {
        TFARecentlyDeletedView()
    }
}
