//
//  Database.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Database: class {
    func saveHotels(_ hotels: [Hotel])
    func updateHotel(_ hotel: Hotel)
    func getHotels() -> Observable<[Hotel]>
    func getHotel(withId id: Int) -> Observable<Hotel>
}
