//
//  DataManager.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 14/06/21.
//

import Foundation
import KeychainAccess
import CoreVideo
import CoreText


class DataManager {
    static let shared = DataManager()
    let keychain = Keychain(accessGroup: Constants.group)
    
    private init() {}
    
    func writeDataToKeyChain<T: Codable>(for key: String, value: T) throws {
        var encodedData: Data? = nil
        do {
            encodedData = try JSONEncoder().encode(value)
        } catch {
            throw TFAError.invalidEncoding
        }
        
        guard let encodedData = encodedData else { throw TFAError.unwrappingFailed }
        
        do {
            try keychain.set(encodedData, key: key)
        } catch {
            throw TFAError.keychainError(error: "Unable to set data in keychain")
        }
    }
    
    func readDataFromKeyChain<T: Codable>(from key: String, value: T.Type) throws -> T {
        var encodedData: Data? = nil
    
        do {
            encodedData = try keychain.getData(key)
        } catch {
            throw TFAError.keychainError(error: "Unable to get data in keychain")
        }
        
        guard let encodedData = encodedData else { throw TFAError.unwrappingFailed }
        
        do {
            let decodedData = try JSONDecoder().decode(value, from: encodedData)
            return decodedData
        } catch {
            throw TFAError.invalidEncoding
        }
    }
    
    
 
    
    
    
    
}

