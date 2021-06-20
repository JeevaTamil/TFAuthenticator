//
//  Extensions.swift
//  TFAuthenticator
//
//  Created by Azhagusundaram Tamil on 20/06/21.
//

import Foundation

extension String {
    func separating(every: Int, separator: String) -> String {
        let regex = #"(.{\#(every)})(?=.)"#
        return self.replacingOccurrences(of: regex, with: "$1\(separator)", options: [.regularExpression])
    }
}
