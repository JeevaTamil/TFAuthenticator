//
//  WatchViewModel.swift
//  WatchViewModel
//
//  Created by Azhagusundaram Tamil on 08/09/21.
//

import Foundation
import SwiftOTP
import Combine

class WatchViewModel: ObservableObject {
//    //private let dataManager: DataManager = DataManager.shared
//    
//    var otps = CurrentValueSubject<[OTP], Never>([])
//    var recentlyDeleted = CurrentValueSubject<[OTP], Never>([])
//    
//    init() {
//        loadOTP()
//    }
//    
//    func loadOTP() {
//        do {
//            let otpArray = try dataManager.readDataFromKeyChain(from: Constants.keys.kOTParray, value: [OTP].self)
//            let recentlyDeletedotpArray = try dataManager.readDataFromKeyChain(from: Constants.keys.kRecentlyDeletedOTParray, value: [OTP].self)
//            DispatchQueue.main.async {
//                self.objectWillChange.send()
//                self.otps.value = otpArray
//                self.recentlyDeleted.value = recentlyDeletedotpArray
//                debugPrint(otpArray)
//                debugPrint(recentlyDeletedotpArray)
//            }
//        } catch {
//            self.objectWillChange.send()
//            print(error.localizedDescription)
//            //self.error.value = error as? TFAError
//        }
//    }
    
    func generateOTPs(otp: OTP) -> String {
        guard let data = base32DecodeToData(otp.id) else { return ""}
        
        let totp = TOTP(secret: data, digits: otp.digits, timeInterval: otp.period, algorithm: .sha1)
        let now = Date()
        let timeStamp = now.timeIntervalSince1970
        
        guard let totp = totp else { return ""}
        let code = totp.generate(time: Date.init(timeIntervalSince1970: timeStamp))?.separating(every: 3, separator: " ")
        guard let codeVal = code else {
            return "123 456"
        }
        return codeVal
    }
}
