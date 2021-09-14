//
//  OTPViewModel.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation
import Combine
import SwiftOTP

class OTPViewModel: ObservableObject {
    var phoneSessionViewModel: PhoneSessionViewModel!
    private let dataManager: DataManager = DataManager.shared
    
    var otps = CurrentValueSubject<[OTP], Never>([])
    var recentlyDeleted = CurrentValueSubject<[OTP], Never>([])
    var staredOtps = CurrentValueSubject<[OTP], Never>([])
    
    var error = CurrentValueSubject<TFAError?, Never>(nil)
    var addOTP = PassthroughSubject<OTP, Never>()
    var updateOTP = PassthroughSubject<OTP, Never>()
    var deleteOTP = PassthroughSubject<OTP, Never>()
    var starOTP = PassthroughSubject<OTP, Never>()
    var restoreOTP = PassthroughSubject<OTP, Never>()
    var deleteRecentOTP = PassthroughSubject<OTP, Never>()
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        phoneSessionViewModel = PhoneSessionViewModel()
        loadOTP()
        subscriptions()
        subscribeOTP()
    }
    
    func subscriptions() {
        addOTP
            .receive(on: DispatchQueue.main)
            .sink { [self] otp in
                self.objectWillChange.send()
                otps.value.append(otp)
            }
            .store(in: &cancellable)
        
        updateOTP
            .sink { [unowned self] otp in
                guard let index = otps.value.firstIndex(where: { $0.id == otp.id }) else { return }
                self.objectWillChange.send()
                otps.value[index] = otp
            }
            .store(in: &cancellable)
        
        deleteOTP
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] otp in
                self.objectWillChange.send()
                if let index = otps.value.firstIndex(where: { $0.id == otp.id}) {
                    recentlyDeleted.value.append(otps.value[index])
                    otps.value.remove(at: index)
                }
            }
            .store(in: &cancellable)
        
        starOTP
            .receive(on: DispatchQueue.main)
            .sink { [self] otp in
                self.objectWillChange.send()
                guard let index = otps.value.firstIndex(where: {$0.id == otp.id}) else { return }
                otps.value[index].isStared.toggle()
            }
            .store(in: &cancellable)
        
        restoreOTP
            .receive(on: DispatchQueue.main)
            .sink { [self] otp in
                self.objectWillChange.send()
                guard let index = recentlyDeleted.value.firstIndex(where: {$0.id == otp.id}) else { return }
                recentlyDeleted.value.remove(at: index)
                otps.value.append(otp)
                debugPrint("Deleted completely")
            }
            .store(in: &cancellable)
        
        deleteRecentOTP
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] otp in
                self.objectWillChange.send()
                if let index = recentlyDeleted.value.firstIndex(where: { $0.id == otp.id}) {
                    recentlyDeleted.value.remove(at: index)
                }
            }
            .store(in: &cancellable)
        
    }
    
    func subscribeOTP() {
        otps
            .subscribe(on: DispatchQueue.init(label: "bg"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .tryMap { [self] otps in
                try dataManager.writeDataToKeyChain(for: Constants.keys.kOTParray, value: otps)
                self.sendOTPArrayToWatch()
            }
            .sink { complition in
                switch complition {
                case .failure(let error):
                    self.objectWillChange.send()
                    self.error.value = error as? TFAError
                case .finished:
                    debugPrint("finished")
                }
            } receiveValue: { _ in
                debugPrint("otps saved")
            }
            .store(in: &cancellable)
        
        recentlyDeleted
            .receive(on: DispatchQueue.main)
            .tryMap { [self] otps in
                try dataManager.writeDataToKeyChain(for: Constants.keys.kRecentlyDeletedOTParray, value: otps)
            }
            .sink { complition in
                switch complition {
                case .failure(let error):
                    self.objectWillChange.send()
                    self.error.value = error as? TFAError
                case .finished:
                    debugPrint("finished")
                }
            } receiveValue: { _ in
                debugPrint("otps saved in recently deleted")
            }
            .store(in: &cancellable)
        
    }
    
    func loadOTP() {
        do {
            let otpArray = try dataManager.readDataFromKeyChain(from: Constants.keys.kOTParray, value: [OTP].self)
            let recentlyDeletedotpArray = try dataManager.readDataFromKeyChain(from: Constants.keys.kRecentlyDeletedOTParray, value: [OTP].self)
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.otps.value = otpArray
                self.recentlyDeleted.value = recentlyDeletedotpArray
                self.sendOTPArrayToWatch()
                debugPrint(otpArray)
                debugPrint(recentlyDeletedotpArray)
            }
        } catch {
            self.objectWillChange.send()
            self.error.value = error as? TFAError
        }
    }
    
    func editOrderofOTP(indexSet: IndexSet, index: Int) {
        self.objectWillChange.send()
        otps.value.move(fromOffsets: indexSet, toOffset: index)
    }
    
    func generateOTPs(otp: OTP) -> String {
        guard let data = base32DecodeToData(otp.id) else {
            self.objectWillChange.send()
            error.value = TFAError.invalidSecret
            return ""
        }
        
        let totp = TOTP(secret: data, digits: otp.digits, timeInterval: otp.period, algorithm: .sha1)
        let now = Date()
        let timeStamp = now.timeIntervalSince1970
        
        guard let totp = totp else {
            self.objectWillChange.send()
            error.value = TFAError.unableToCreateOTPObj
            return ""
        }
        let code = totp.generate(time: Date.init(timeIntervalSince1970: timeStamp))?.separating(every: 3, separator: " ")
        guard let codeVal = code else {
            return "123 456"
        }
        return codeVal
    }
    
    func sendOTPArrayToWatch() {
       // let message: [String: [OTP]] = ["otpArr": otps.value]
        debugPrint("OTPs shared to watch")
        //        phoneSessionViewModel.session.sendMessage(message, replyHandler: nil) { error in
        //            self.error.value = TFAError.unableToCreateOTPObj
        //        }
        
        do {
            let encodedData = try JSONEncoder().encode(self.otps.value)
            phoneSessionViewModel.session.sendMessageData(encodedData, replyHandler: nil) { error in
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
