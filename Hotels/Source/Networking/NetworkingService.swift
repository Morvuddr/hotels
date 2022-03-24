//
//  NetworkingService.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol NetworkingService: class {
    func getHotels() -> Observable<[Hotel]>
    func getHotelInfo(hotelId: Int) -> Observable<Hotel?>
    func getHotelImage(imageId: Int) -> Observable<Data>
}
