//
//  HotelTableViewCellModel.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation

protocol HotelTableViewCellModeling {
    var hotelName: String { get }
    var availableRooms: String { get }
    var stars: String { get }
    var address: String { get }
}

struct HotelTableViewCellModel: HotelTableViewCellModeling {
    
    var hotelName: String
    var availableRooms: String
    var stars: String
    var address: String
    
    init(hotel: HotelStruct) {
        self.hotelName = hotel.name
        self.availableRooms = Messages.availableRooms + "\(hotel.suitesAvailability.count)"
        self.stars = "\(Int(hotel.stars))"
        self.address = hotel.address
    }
    
}
