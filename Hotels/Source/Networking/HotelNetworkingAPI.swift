//
//  HotelNetworkingAPI.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RxSwift

final class HotelsNetworkingAPI: NetworkingService {
    
    private let baseURL = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/"
    
    func getHotels() -> Observable<[Hotel]> {
        guard let url = URL(string: baseURL + "0777.json") else { return Observable.just([]) }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data -> [Hotel] in
                var hotels = [Hotel]()
                do {
                    hotels = try JSONDecoder().decode([Hotel].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
                return hotels
        }
    }
    
    func getHotelInfo(hotelId: Int) -> Observable<Hotel?> {
        guard let url = URL(string: baseURL + "\(hotelId).json") else {
            return Observable.error(ErrorModel(.badNetwork))
        }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data -> Hotel? in
                return try? JSONDecoder().decode(Hotel.self, from: data)
        }
    }
    
    func getHotelImage(imageId: Int) -> Observable<Data> {
        guard let url = URL(string: baseURL + "\(imageId).jpg") else { return Observable.empty() }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
    }
    
}
