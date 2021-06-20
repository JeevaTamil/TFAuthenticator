//
//  LoginView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 17/06/21.
//

import SwiftUI

struct LoginForm: View {
    enum Field: Hashable {
        case username
        case password
    }

    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .focused($focusedField, equals: .username)

            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)

            Button("Sign In") {
                if username.isEmpty {
                    focusedField = .username
                } else if password.isEmpty {
                    focusedField = .password
                } else {
                    //handleLogin(username, password)
                    print("user name - " + username)
                    print("password - " + password)
                }
            }
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}
