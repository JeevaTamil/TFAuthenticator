//
//  DataManagerProtocol.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 20/06/21.
//

import Foundation

protocol ViewModelProtocol {
    func fetchOTPs() -> [OTP]
    func addOTP(otp: OTP)
  //  func editOTP(indexSet: IndexSet)
  //  func deleteOTP(otp: OTP)
}
