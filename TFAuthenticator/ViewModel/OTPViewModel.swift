//
//  OTPViewModel.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation
import Combine

class OTPViewModel: ObservableObject {
    private let dataManager: DataManager = DataManager.shared
        
    var otps = CurrentValueSubject<[OTP], Never>([])
    var error = CurrentValueSubject<TFAError?, Never>(nil)
    var addOTP = PassthroughSubject<OTP, Never>()
    
    var cancellable = Set<AnyCancellable>()
    func subscriptions() {
        addOTP
            .sink { [self] otp in
                self.objectWillChange.send()
                otps.value.append(otp)
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
            }
        } catch {
            self.objectWillChange.send()
            self.error.value = error as? TFAError
        }
    }
}
