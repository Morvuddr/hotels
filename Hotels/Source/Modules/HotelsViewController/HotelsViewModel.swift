//
//  HotelsViewModel.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HotelsViewModeling: class {
    var viewWillAppear: PublishSubject<Void> { get }
    var selectedIndexPath: PublishSubject<IndexPath> { get }
    var selectedSort: BehaviorSubject<Sorting> { get }
    var loading: Driver<Bool> { get }
    var hotels: Driver<[HotelTableViewCellModeling]> { get }
    var selectedHotelId: Driver<Int> { get }
    var error: Driver<ErrorModel> { get }
}

enum Sorting: Int {
    case none, rooms, distance
}

class HotelsViewModel: HotelsViewModeling {
    
    // MARK: - Properties
    // Input
    var viewWillAppear = PublishSubject<Void>()
    var selectedSort = BehaviorSubject<Sorting>(value: .none)
    var selectedIndexPath = PublishSubject<IndexPath>()
    
    // Output
    var loading: Driver<Bool>
    var hotels: Driver<[HotelTableViewCellModeling]>
    var selectedHotelId: Driver<Int>
    var error: Driver<ErrorModel>
    
    // Private
    private let disposeBag = DisposeBag()
    private let database: Database
    private let networkingService: NetworkingService
    
    // MARK: - Lifecycle
    init(database: Database, networkingService: NetworkingService) {
        self.database = database
        self.networkingService = networkingService
        
        let loading = BehaviorSubject<Bool>(value: false)
        self.loading = loading.asDriver(onErrorJustReturn: false)
        
        let error = PublishSubject<ErrorModel>()
        self.error = error.asDriver(onErrorJustReturn: ErrorModel(.general))
        
        self.viewWillAppear
            .asObservable()
            .take(1)
            .flatMap { _ -> Observable<[Hotel]> in
                return networkingService.getHotels()
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .do(onNext: { _ in loading.onNext(false) },
                        onError: { _ in error.onNext(ErrorModel(.badNetwork)) },
                        onSubscribed: { loading.onNext(true) })
            }
            .filterErrors()
            .subscribe(onNext: { hotels in
                database.saveHotels(hotels)
            })
            .disposed(by: disposeBag)
        
        let hotels = database.getHotels()
            .filter({ !$0.isEmpty })
            .distinctUntilChanged({ $0.count == $1.count })
            .map({ $0.map{ HotelStruct(hotel: $0 )} })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        
        let sortedHotels = Observable.combineLatest(hotels, selectedSort)
            .map { (hotels, sorting) -> [HotelStruct] in
                var hotels = hotels
                switch sorting {
                case .rooms:
                    hotels.sort(by: { $0.suitesAvailability.count > $1.suitesAvailability.count })
                case .distance:
                    hotels.sort(by: { $0.distance < $1.distance })
                default: break
                }
                return hotels
            }
        
        self.hotels = sortedHotels.map({ $0.map { HotelTableViewCellModel(hotel: $0) } }).asDriver(onErrorJustReturn: [])
        
        self.selectedHotelId = selectedIndexPath
            .asObservable()
            .withLatestFrom(sortedHotels) { indexPath, hotels in
                return hotels[indexPath.row].id
            }
            .asDriver(onErrorJustReturn: 0)
            .filter({ $0 != 0 })
    }
    
}
