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
    @State private var isSettingsPresent = false
    @State private var isToastPresented = false
    @State private var searchText: String = ""
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main,  in: .common).autoconnect()
    
    var body: some View {
        List {
            TFAListWrapperView(timeRemaining: $timeRemaining, isToastPresented: $isToastPresented, otps: searchResults)
        }
        .searchable(text: $searchText, placement: .sidebar)
        .showToast("Copied", isPresented: $isToastPresented, color: .secondary, duration: 1, alignment: .bottom, toastType: .offsetToast)
        .navigationBarTitle("Authenticator")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    settingsButton
                    Spacer()
                    Text("Add Accounts")
                        .foregroundStyle(.secondary)
                    Spacer()
                    addButton
                }
                .ignoresSafeArea(edges: .horizontal)
            }
        }
        .sheet(item: $modelView) { $0 }
        .fullScreenCover(isPresented: $isSettingsPresent) { SettingsView() }
        .onReceive(timer, perform: { _ in
            scheduleTimer()
        })
        
    }
    
    var searchResults: [OTP] {
        if searchText.isEmpty {
            return otpViewModel.otps.value
        } else {
            return otpViewModel.otps.value.filter{ $0.issuer.starts(with: searchText) }
        }
    }
}


extension TFAListView {
    
    var settingsButton: some View {
        Button {
            //modelView = .settings
            isSettingsPresent.toggle()
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


