//
//  ErrorModel.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation

class ErrorModel: Error {
    
    // MARK: - Properties
    var message: String
    
    var localizedDescription: String {
        return message
    }
    
    init(_ message: ErrorMessage) {
        self.message = message.rawValue
    }
}

// MARK: - Public Functions
extension ErrorModel {
    
    class func generalError() -> ErrorModel {
        return ErrorModel(.general)
    }
}
