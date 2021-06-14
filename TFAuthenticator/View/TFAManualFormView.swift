//
//  TFAManualFormView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import SwiftUI

struct TFAManualFormView: View {
    @State private var issuer: String = ""
    @State private var accName: String = ""
    @State private var token: String = ""
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        Form {
            TextField("Google, Facebook, Twitter...", text: $issuer)
                .focused($focusedField, equals: .issuer)
                .textContentType(.givenName)
                .submitLabel(.next)
            
            TextField("abc@wyz.com", text: $accName)
                .focused($focusedField, equals: .accName)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
            
            TextField("ABCDEFGHIJKL", text: $token)
                .focused($focusedField, equals: .token)
                .textCase(.uppercase)
                .submitLabel(.done)
        }
        .onSubmit {
            switch focusedField {
            case .issuer:
                focusedField = .accName
            case .accName:
                focusedField = .token
            default:
                debugPrint("done")
            }
        }
        .navigationBarTitle("Add Account")
    }
    
    enum Field {
        case issuer
        case accName
        case token
    }
}

struct TFAManualFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TFAManualFormView()
        }
    }
}
