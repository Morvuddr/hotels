//
//  HotelStruct.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation

struct HotelStruct: Equatable {
    let id: Int
    let name: String
    let address: String
    let stars: Float
    let distance: Float
    let image: String
    let lat: Double
    let lon: Double
    let suitesAvailability: [Int]
}

extension HotelStruct {
    
    init(hotel: Hotel) {
        self.id = hotel.id
        self.name = hotel.name
        self.address = hotel.address
        self.stars = hotel.stars
        self.distance = hotel.distance
        self.image = hotel.image
        self.lat = hotel.lat
        self.lon = hotel.lon
        self.suitesAvailability = Array(hotel.suitesAvailability)
    }
    
}
