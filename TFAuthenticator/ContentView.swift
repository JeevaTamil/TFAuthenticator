//
//  ContentView.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var otpViewModel: OTPViewModel = OTPViewModel()
    
    
    @State private var reachability = "status"
    @State private var enterText: String = ""
    var body: some View {
        NavigationView {
            TFAListView()
                .environmentObject(otpViewModel)
//            VStack {
//                Text(reachability)
//
//                Button {
//                    if otpViewModel.phoneSessionViewModel.session.isReachable {
//                        reachability = "connected"
//                    } else {
//                        reachability = "non connected"
//                    }
//                } label: {
//                     Text("check")
//                }
//
//                TextField("Enter message here", text: $enterText, prompt: Text("Pass message"))
//
//                Button {
//                    otpViewModel.phoneSessionViewModel.session.sendMessage(["message": enterText], replyHandler: nil) { error in
//                        print(error.localizedDescription)
//                    }
//                } label: {
//                    Text("send")
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
