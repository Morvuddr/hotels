//
//  HotelInfoViewModel.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HotelInfoViewModeling: class {
    var viewWillAppear: PublishSubject<Void> { get }
    var locationTapped: PublishSubject<Void> { get }
    var hotelName: Driver<String> { get }
    var hotelAddress: Driver<String> { get }
    var hotelStars: Driver<String> { get }
    var hotelImageData: Driver<Data> { get }
    var hotelRooms: Driver<String> { get }
    var showMap: Driver<(Double, Double)> { get }
    var loading: Driver<Bool> { get }
    var error: Driver<ErrorModel> { get }
}

class HotelInfoViewModel: HotelInfoViewModeling {
    
    // MARK: - Properties
    var viewWillAppear = PublishSubject<Void>()
    var locationTapped = PublishSubject<Void>()
    
    // Output
    var hotelName: Driver<String>
    var hotelAddress: Driver<String>
    var hotelStars: Driver<String>
    var hotelImageData: Driver<Data>
    var hotelRooms: Driver<String>
    var showMap: Driver<(Double, Double)>
    var loading: Driver<Bool>
    var error: Driver<ErrorModel>
    
    // Private
    private let disposeBag = DisposeBag()
    private let database: Database
    private let networkingService: NetworkingService
    private let dataManager: DataManager
    private let imageCropper: ImageCropper
    
    // MARK: - Lifecycle
    init(hotelId: Int, database: Database, networkingService: NetworkingService, dataManager: DataManager, imageCropper: ImageCropper) {
        self.database = database
        self.networkingService = networkingService
        self.dataManager = dataManager
        self.imageCropper = imageCropper
        
        let loading = BehaviorSubject<Bool>(value: false)
        self.loading = loading.asDriver(onErrorJustReturn: false)
        
        let error = PublishSubject<ErrorModel>()
        self.error = error.asDriver(onErrorJustReturn: ErrorModel(.general))
        
        self.viewWillAppear
            .asObservable()
            .take(1)
            .flatMap { (_) -> Observable<Hotel?> in
                return networkingService.getHotelInfo(hotelId: hotelId)
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .do(onNext: { _ in loading.onNext(false) },
                        onError: { _ in error.onNext(ErrorModel(.badNetwork)) },
                        onSubscribed: { loading.onNext(true) })
                    .filterErrors()
            }
            .compactMap { $0 }
            .subscribe(onNext: { hotel in
                database.updateHotel(hotel)
            })
            .disposed(by: disposeBag)
        
        let hotel = database.getHotel(withId: hotelId)
            .map({ HotelStruct(hotel: $0) })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .share(replay: 1)
        
        self.hotelName = hotel.map{ $0.name }.asDriver(onErrorJustReturn: "")
        self.hotelAddress = hotel.map{ $0.address }.asDriver(onErrorJustReturn: "")
        self.hotelStars = hotel.map{ "\($0.stars)" }.asDriver(onErrorJustReturn: "")
        self.hotelRooms = hotel.map{ Messages.availableRooms + "\($0.suitesAvailability.count)" }
            .asDriver(onErrorJustReturn: "")
        
        self.showMap = locationTapped.withLatestFrom( hotel.map{ ($0.lat, $0.lon) })
            .asDriver(onErrorJustReturn: (0.0, 0.0))
            .filter({ $0 != (0.0, 0.0) })

        self.hotelImageData = hotel
            .compactMap({ Int($0.image.components(separatedBy: ".")[0]) })
            .take(1)
            .flatMap { Observable.zip(Observable.just($0), dataManager.loadData(forKey: "\($0)")) }
            .flatMap({ imageId, data -> Observable<Data> in
                guard let data = data else {
                    return networkingService
                        .getHotelImage(imageId: imageId)
                        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                        .flatMap({ (imgData) -> Observable<Data> in
                            return imageCropper.cropImageBorder(for: imgData, borderWidth: 1)
                        })
                        .do(onNext: {
                            dataManager.save(data: $0, forKey: "\(imageId)")
                            loading.onNext(false)
                            },
                            onError: { _ in error.onNext(ErrorModel(.failedToLoadImage)) },
                            onSubscribed: { loading.onNext(true) })
                }
                return Observable.just(data)
            })
            .asDriver(onErrorJustReturn: Data())
        
    }
    
}
