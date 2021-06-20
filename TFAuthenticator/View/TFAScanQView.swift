//
//  TFAScanQView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 21/06/21.
//

import SwiftUI
import SwiftOTP


struct TFAScanQView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var otpViewModel: OTPViewModel
    
    var body: some View {
        
        ZStack {
            VStack {
                CodeScannerView(codeTypes: [.qr]) { result in
                    switch result {
                    case .success(let code):
                        addOTPFromURL(otpURL: code)
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .navigationBarTitle("Scan QR Code", displayMode: .inline)
            .navigationBarItems(leading: cancelButton)
        }
        
    }
}

extension TFAScanQView {
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
        
    func addOTPFromURL(otpURL: String) {
        var secret = ""
        var issuer = ""
        var period = ""
        var algorithm = ""
        var digit = ""
        var count = ""
        
        guard  let components = URLComponents(string: otpURL) else { return }
        guard components.queryItems != nil  else { return }
        
        var accName = components.path.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ":", with: "")
        
        guard let queryItems = components.queryItems else { return }
        
        for queryItem in queryItems {
            for param in parameters.allCases {
                
                if queryItem.name.lowercased() == param.rawValue.lowercased() {
                    switch param {
                    case .secret:
                        secret = queryItem.value!
                    case .issuer:
                        issuer = queryItem.value!
                    case .algorithm:
                        algorithm = queryItem.value!
                    case .period:
                        period = queryItem.value!
                    case .digits:
                        digit = queryItem.value!
                    case .counter:
                        count = queryItem.value!
                    }
                }
            }
        }
        
        accName = accName.replacingOccurrences(of: issuer.replacingOccurrences(of: " ", with: ""), with: "")
        
        let otp = OTP(issuer: issuer, accName: accName, id: secret, period: (period == "" ? 30 : Int(period)!), digits: digit == "" ? 6 : Int(digit)!, algorithm: algorithm == "" ? "SHA1" : algorithm, isStared: false)
        otpViewModel.addOTP.send(otp)
    }
    
    enum parameters: String, CaseIterable {
        case secret = "Secret"
        case issuer = "Issuer"
        case algorithm = "Algorithm"
        case digits = "Digits"
        case counter = "Counter"
        case period = "Period"
    }
}
