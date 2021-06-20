//
//  AlertMessage.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 20/06/21.
//

import Foundation
import SwiftUI

enum Message {
    /// A message and OK button
    case information(body: String)
    /// A message and OK button
    case warning(body: String)
    /// A question with YES and NO buttons
    case confirmation(body: String, action: () -> Void)
    /// A question about destractive action with `action` and CANCEL buttons
    case destruction(body: String, label: String, action: () -> Void)
}

extension Message: Identifiable {
    var id: String { String(reflecting: self) }
}

extension Message {
    /// Builder of an Alert
    func show() -> Alert {
        switch self {

        case let .confirmation(body, action):
            return Alert(
                title: Text("Confirmation"),
                message: Text(body),
                primaryButton: .default(Text("YES"), action: action),
                secondaryButton: .cancel(Text("NO")))

        case let .information(body):
            return Alert(
                title: Text("Information"),
                message: Text(body))

        case let .warning(body):
            return Alert(
                title: Text("Warning"),
                message: Text(body))

        case let .destruction(body, label, action):
            return Alert(
                title: Text("Confirmation"),
                message: Text(body),
                primaryButton: .destructive(Text(label), action: action),
                secondaryButton: .cancel())
        }
    }
}

extension View {
    func alert(with message: Binding<Message?>) -> some View {
        self.alert(item: message) { $0.show() }
    }
}
