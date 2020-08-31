//
//  RealmDatabase.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

class RealmDatabase: Database {
    
    func saveHotels(_ hotels: [Hotel]) {
        let realm = try! Realm()
        
        do {
            try realm.write{
                realm.add(hotels, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateHotel(_ hotel: Hotel) {
        let realm = try! Realm()
        
        do {
            try realm.write{
                realm.add(hotel, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getHotels() -> Observable<[Hotel]> {
        
        let realm = try! Realm()
        let hotels = realm.objects(Hotel.self)
        return Observable.array(from: hotels)
    }
    
    func getHotel(withId id: Int) -> Observable<Hotel> {
        let realm = try! Realm()
        
        guard let hotel = realm.object(ofType: Hotel.self, forPrimaryKey: id) else {
            return Observable.error(ErrorModel(.failedToLoadHotel))
        }
        return Observable.from(object: hotel)
    }
    
}
