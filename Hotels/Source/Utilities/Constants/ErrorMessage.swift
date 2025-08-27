//
//  ErrorMessage.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation

enum ErrorMessage: String {
    case general = "Error occurred"
    case badNetwork = "Failed to load data. Try again later."
    case failedToLoadImage = "Failed to load image"
    case failedToLoadHotel = "Failed to load hotel information"
}
