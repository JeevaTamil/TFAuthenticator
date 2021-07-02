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
    @ObservedObject var formVM: OTPFormViewModel
    @FocusState private var focusedField: Field?
    @EnvironmentObject var otpViewModel: OTPViewModel
    @Environment(\.dismiss) var dismiss
    @State private var message: Message?
    
    @State private var issuerChange: Bool = false
    @State private var accNameChange: Bool = false
    @State private var tokenChange: Bool = false
    @State private var backupCodePlaceholder = true
    
    var body: some View {
        Form {
            Section(header: Text(kFormFields.basicOptionsTitle)) {
                FormFieldView(fieldString: $formVM.issuer, isEditingChanged: $issuerChange, fieldName: kFormFields.issuerFieldName, placeholder: kFormFields.issuerPlaceholder)
                    .focused($focusedField, equals: .issuer)
                    .submitLabel(.next)
                
                FormFieldView(fieldString: $formVM.accName, isEditingChanged: $accNameChange, fieldName: kFormFields.accNameFieldName, placeholder: kFormFields.accNamePlaceholder)
                    .focused($focusedField, equals: .accName)
                    .keyboardType(.emailAddress)
                    .textContentType(.givenName)
                    .submitLabel(.next)
                
                FormFieldView(fieldString: $formVM.token, isEditingChanged: $tokenChange, fieldName: kFormFields.tokenFieldName, placeholder: kFormFields.tokenPlaceholder)
                    .focused($focusedField, equals: .token)
                    .submitLabel(.next)
            }
            Section(header: Text(kFormFields.extensionTitle)) {
                Toggle(isOn: $formVM.isWidgetAllowed) {
                    Label("Widget", systemImage: "square.inset.filled")
                        .symbolRenderingMode(.hierarchical)
                }
                Toggle(isOn: $formVM.isWatchAllowed) {
                    Label("Apple Watch", systemImage: "watchface.applewatch.case")
                    //.foregroundStyle(.green, .regularMaterial)
                        .symbolRenderingMode(.hierarchical)
                }
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
            
            ToolbarItem(placement: .cancellationAction) { cancelButton }
            ToolbarItem(placement: .confirmationAction) { updateSaveButton }
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
            TFAManualFormView(formVM: OTPFormViewModel())
        }
    }
}

struct FormFieldView: View {
    @Binding var fieldString: String
    @Binding var isEditingChanged: Bool
    var fieldName: String
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .foregroundColor(isEditingChanged ? .blue : .secondary)
                .font(.footnote)
            TextField(placeholder, text: $fieldString) { (val) in
                withAnimation {
                    isEditingChanged = val
                }
            }
            .textCase(fieldName == kFormFields.tokenFieldName ? .uppercase : .lowercase)
        }
    }
}

extension TFAManualFormView {
    func addOTP() {
        let otpObj = OTP(issuer: formVM.issuer, accName: formVM.accName, id: formVM.token, isWidgetAllowed: formVM.isWidgetAllowed, isWatchAllowed: formVM.isWatchAllowed)
        otpViewModel.addOTP.send(otpObj)
        dismiss()
    }
    
    func updateOTP() {
        let otpObj = OTP(issuer: formVM.issuer, accName: formVM.accName, id: formVM.token, isWidgetAllowed: formVM.isWidgetAllowed, isWatchAllowed: formVM.isWatchAllowed)
        otpViewModel.updateOTP.send(otpObj)
//        dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(formVM.updating ? "Update" : "Save", action: formVM.updating ? updateOTP : addOTP)
            .disabled(formVM.isDisabled)
    }
}
