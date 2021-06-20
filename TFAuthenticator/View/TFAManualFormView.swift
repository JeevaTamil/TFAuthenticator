//
//  TFAManualFormView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import SwiftUI
import SwiftOTP

struct TFAManualFormView: View {
    enum Field: Hashable {
        case issuer
        case accName
        case token
    }
    
    @State private var issuer: String = ""
    @State private var accName: String = ""
    @State private var token: String = ""
    @FocusState private var focusedField: Field?
    @EnvironmentObject var otpViewModel: OTPViewModel
    @Environment(\.dismiss) var dismiss
    @State private var message: Message?
    
    var body: some View {
        Form {
            Section {
            TextField("Google, Facebook, Twitter...", text: $issuer)
                .focused($focusedField, equals: .issuer)
                .submitLabel(.next)
            }
            Section {
            TextField("abc@wyz.com", text: $accName)
                .focused($focusedField, equals: .accName)
                .keyboardType(.emailAddress)
                .textContentType(.givenName)
                .submitLabel(.next)
            }
            Section {
            TextField("ABCDEFGHIJKL", text: $token)
                .focused($focusedField, equals: .token)
                .textCase(.uppercase)
                .submitLabel(.done)
            }
            Section {
            Button("ADD") {
                guard let _ = base32DecodeToData(token) else {
                    self.message = .warning(body: "string length is invalid.")
                    return
                }
                
                let otpObj = OTP(issuer: issuer, accName: accName, id: token)
                otpViewModel.addOTP.send(otpObj)
                dismiss()
            }
            //.buttonStyle(.bordered)
            .controlProminence(.increased)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: previousField) {
                    Label("Previous", systemImage: "chevron.up")
                }
                .allowsHitTesting(focusedField != .issuer)
                
                Button(action: nextField) {
                    Label("Next", systemImage: "chevron.down")
                }
                .allowsHitTesting(focusedField != .token)
            }
        }
        //.padding()
        .onSubmit {
            switch focusedField {
            case .issuer:
                focusedField = .accName
            case .accName:
                focusedField = .token
            case nil:
                focusedField = .accName
                print("Focus field - \(String(describing: focusedField))")
            default:
                focusedField = nil
                print("Focus field - \(String(describing: focusedField))")
            }
        }
        .alert(with: $message)
        .navigationBarTitle("Add Account")
        
    }
    
    func previousField() {
        switch focusedField {
        case .issuer:
            focusedField = nil
        case .accName:
            focusedField = .issuer
        default:
            focusedField = .accName
            print("Focus field - \(String(describing: focusedField))")
        }
    }
    
    func nextField() {
        switch focusedField {
        case .issuer:
            focusedField = .accName
        case .accName:
            focusedField = .token
        case nil :
            focusedField = .issuer
        default:
            print("Focus field - \(String(describing: focusedField))")
        }
    }
}

struct TFAManualFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TFAManualFormView()
        }
    }
}
