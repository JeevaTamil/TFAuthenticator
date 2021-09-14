//
//  WatchSessionViewModel.swift
//  WatchSessionViewModel
//
//  Created by Azhagusundaram Tamil on 10/09/21.
//

import Foundation
import WatchConnectivity
import KeychainAccess

class WatchSessionViewModel: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var otpArr: [OTP] = []
    @Published var messageText: String = "default"
    let keychain = Keychain()
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        fetchDataFromKeyChain()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            //            let otp = message["otpArr"]
            //            self.otpArr.append(otp as! OTP)
            self.messageText = message["message"] as! String
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
        self.storeDataInKeyChain(data: messageData, for: "watch")
        fetchDataFromKeyChain()
        
//        do {
//
//            guard let data = try keychain.getData("watch") else { return }
//
//            let otp = try JSONDecoder().decode([OTP].self, from: data)
//            DispatchQueue.main.async {
//                self.otpArr = otp
//            }
//            //self.messageText = otp.accName
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func storeDataInKeyChain(data: Data, for key: String) {
        do {
            try keychain.set(data, key: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchDataFromKeyChain() {
        do {
            guard let data = try keychain.getData("watch") else { return }
            
            let otp = try JSONDecoder().decode([OTP].self, from: data)
            DispatchQueue.main.async {
                self.otpArr = otp
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
