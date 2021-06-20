//
//  TFAListView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import SwiftUI

struct TFAListView: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    @State private var shouldDisplayAddManualForm: Bool = false
    @State private var timeRemaining = Int()
    @State private var modelView: ModelView? = nil
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main,  in: .common).autoconnect()
    
    var body: some View {
        List {
            if otpViewModel.otps.value.filter({$0.isStared}).count != 0 {
                Section(header: Text("Stared")) {
                    AccountsView(timeRemaining: $timeRemaining, otps: otpViewModel.otps.value.filter({$0.isStared}))
                }
            }
            if otpViewModel.otps.value.filter({!$0.isStared}).count != 0 {
                Section(header: Text("Accounts")) {
                    AccountsView(timeRemaining: $timeRemaining, otps: otpViewModel.otps.value.filter({!$0.isStared}))
                }
            }
        }
        .navigationBarTitle("Authenticator")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
//                    settingsButton
                Spacer()
                Text("Add Accounts")
                        .foregroundStyle(.secondary)
                    Spacer()
                    addButton
                }
               // .background(.thinMaterial)
                .ignoresSafeArea(edges: .horizontal)
            }
//            ToolbarItemGroup(placement: .bottomBar) {
//                ToolbarItem { addButton }
//                ToolbarItem { settingsButton }
//            }
        }
        .sheet(item: $modelView) { $0 }
        .onReceive(timer, perform: { _ in
            scheduleTimer()
        })
        
    }
}


extension TFAListView {
    
    var settingsButton: some View {
        Button {
            modelView = .settings
        } label: {
            Label("Settings", systemImage: "gear")
        }

    }
    
    var addButton: some View {
        Menu {
            Button(action: {
                modelView = .scanQR
            }){
                Label("Scan QR", systemImage: "qrcode")
            }
            Button(action: {
                modelView = .manual
            }){
                Label("Enter Manually", systemImage: "square.and.pencil")
            }
            
        } label: {
            Label("Add", systemImage: "plus.circle.fill")
        }
    }
    
    func scheduleTimer() {
        var components = DateComponents.init()
        components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let second = components.second
        self.timeRemaining = 30 - (second!%30)
    }
}



struct TFAListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(OTPViewModel())
    }
}


