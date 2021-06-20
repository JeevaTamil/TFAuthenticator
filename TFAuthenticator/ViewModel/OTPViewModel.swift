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
    private let dataManager: DataManager = DataManager.shared
    
    var otps = CurrentValueSubject<[OTP], Never>([])
    var staredOtps = CurrentValueSubject<[OTP], Never>([])
    var error = CurrentValueSubject<TFAError?, Never>(nil)
    var addOTP = PassthroughSubject<OTP, Never>()
    var deleteOTP = PassthroughSubject<OTP, Never>()
    var starOTP = PassthroughSubject<OTP, Never>()
    
    @Published var recentlyDeleted: [OTP] = []
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        subscriptions()
        subscribeOTP()
        loadOTP()
    }
    
    func subscriptions() {
        addOTP
            .receive(on: DispatchQueue.main)
            .sink { [self] otp in
                self.objectWillChange.send()
                otps.value.append(otp)
            }
            .store(in: &cancellable)
        
        deleteOTP
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] otp in
                self.objectWillChange.send()
                if let index = otps.value.firstIndex(where: { $0.id == otp.id}) {
                    recentlyDeleted.append(otps.value[index])
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
        
    }
    
    func subscribeOTP() {
        otps
            .subscribe(on: DispatchQueue.init(label: "bg"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .tryMap { [self] otps in
                try dataManager.writeDataToKeyChain(for: Constants.keys.kOTParray, value: otps)
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
    }
    
    func loadOTP() {
        do {
            let otpArray = try dataManager.readDataFromKeyChain(from: Constants.keys.kOTParray, value: [OTP].self)
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.otps.value = otpArray
                debugPrint(otpArray)
            }
        } catch {
            self.objectWillChange.send()
            self.error.value = error as? TFAError
        }
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
        
}
