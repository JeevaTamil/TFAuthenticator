//
//  SettingsView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 21/06/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    SettingsOptionView(title: "Recently Deleted", destination: AnyView(TFARecentlyDeletedView()), imgName: "trash", color: .red)
                }
                
                Section {
                    SettingsOptionView(title: "Write a review", destination: AnyView(Text("Write a review")), imgName: "heart", color: .yellow)
                    SettingsOptionView(title: "Contact us", destination: AnyView(Text("Contact us")), imgName: "envelope", color: .blue)
                    SettingsOptionView(title: "Tell a Friend", destination: AnyView(Text("Tell a Friend")), imgName: "person", color: .green)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct IconView: View {
    var imgName: String
    var color: Color
    var body: some View {
        Image(systemName: imgName)
            .padding(5)
            .foregroundColor(color)
    }
}

struct SettingsOptionView: View {
    var title: String
    var destination: AnyView
    var imgName: String
    var color: Color
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                IconView(imgName: imgName, color: color)
                Text(title)
            }
        }
    }
}

