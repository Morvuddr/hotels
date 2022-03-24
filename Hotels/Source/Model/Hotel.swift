//
//  Hotel.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RealmSwift

final class Hotel: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var stars: Float = 0.0
    @objc dynamic var distance: Float = 0.0
    @objc dynamic var image: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    var suitesAvailability = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int = 0, name: String = "", address: String = "", stars: Float = 0.0, distance: Float = 0.0, image: String = "", lat: Double = 0.0, lon: Double = 0.0) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.stars = stars
        self.distance = distance
        self.image = image
        self.lat = lat
        self.lon = lon
    }
    
    
    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image, lat, lon
        case suitesAvailability = "suites_availability"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.stars = try container.decode(Float.self, forKey: .stars)
        self.distance = try container.decode(Float.self, forKey: .distance)
        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        self.lat = (try? container.decode(Double.self, forKey: .lat)) ?? 0.0
        self.lon = (try? container.decode(Double.self, forKey: .lon)) ?? 0.0
        
        let suitesAvailabilityArray = (try container.decode(String.self, forKey: .suitesAvailability)).components(separatedBy: ":").compactMap(Int.init)
        let suitesAvailabilityList = List<Int>()
        suitesAvailabilityArray.forEach({ suitesAvailabilityList.append($0) })
        self.suitesAvailability = suitesAvailabilityList
    }
    
}
