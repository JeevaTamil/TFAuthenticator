//
//  OTP.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation

struct OTP: Identifiable, Codable {
    var issuer: String
    var accName: String
    var id: String
    var period : Int = 30
    var digits : Int = 6
    var algorithm = "SHA1"
    var isStared: Bool = false
}

extension OTP {
    var mockData: [OTP] {
        return [
            OTP(issuer: "Google", accName: "jeeva_tamilselvan", id: "ASDFGHJKL"),
            OTP(issuer: "Facebook", accName: "jev.jeeva", id: "QWERTYUUIO"),
            OTP(issuer: "Zoho", accName: "azhagusundaram.t@zohocorp.com", id: "MNBVCZXZASDF"),
            OTP(issuer: "Instagram", accName: "Tamil.j", id: "QWERTGVFHBGYJN")
        ]
    }
}

enum Algorithms: String, Hashable {
    case SHA1 = "SHA1"
}
