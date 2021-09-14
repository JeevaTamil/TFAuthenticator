//
//  PhoneSessionViewModel.swift
//  PhoneSessionViewModel
//
//  Created by Azhagusundaram Tamil on 10/09/21.
//

import Foundation
import WatchConnectivity

class PhoneSessionViewModel: NSObject, WCSessionDelegate {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    } 
}
