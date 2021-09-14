//
//  ContentView.swift
//  WatchTFAuthenticator Extension
//
//  Created by Azhagusundaram Tamil on 08/09/21.
//

import SwiftUI

struct ContentView: View {
   // @StateObject var watchViewModel = WatchViewModel()
    
    @StateObject var model = WatchSessionViewModel()
   
    
    var body: some View {
//        List {
//            ForEach(model.otpArr) { otp in
//                Text(otp.accName)
//            }
//        }
        WatchOTPListView(otpArr: model.otpArr)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        //ContentView()
        WatchOTPListView(otpArr: [
            OTP(issuer: "Google", accName: "jeevat13@gmail.com", id: ""),
            OTP(issuer: "Google", accName: "jeevat13@gmail.com", id: ""),
            OTP(issuer: "Google", accName: "jeevat13@gmail.com", id: ""),
            OTP(issuer: "Google", accName: "jeevat13@gmail.com", id: ""),
            OTP(issuer: "Google", accName: "jeevat13@gmail.com", id: ""),
        ])
            .previewDevice("Apple Watch SE - 44mm")
    }
}

struct WatchOTPListView: View {
    @State private var timeRemaining = Int()
    var otpArr: [OTP]
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main,  in: .common).autoconnect()
    
    @StateObject var watchViewModel = WatchViewModel()
    
    var body: some View {
        List {
            ForEach(otpArr) { otp in
                HStack {
                    VStack(alignment: .leading) {
                        Text(otp.issuer)
                            .bold()
                        Text(otp.accName)
                            .font(.caption)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(watchViewModel.generateOTPs(otp: otp))")
                            .bold()
                        Text("\(timeRemaining)")
                            .font(.callout)
                    }
                }
            }
        }
        .onReceive(timer, perform: { _ in
            scheduleTimer()
        })
    }
    
    func scheduleTimer() {
        var components = DateComponents.init()
        components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let second = components.second
        self.timeRemaining = 30 - (second!%30)
    }
}

