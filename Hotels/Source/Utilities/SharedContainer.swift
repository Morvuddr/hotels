//
//  SharedContainer.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Swinject

extension Container {
    
    static let sharedContainer: Container = {
        let container = Container()
        
        // Models
        container.register(NetworkingService.self) { _ in HotelsNetworkingAPI() }
        container.register(Database.self, factory: { _ in RealmDatabase() })
        container.register(DataManager.self) { _ in DataManagerImplementation() }
        container.register(ImageCropper.self, factory: { _ in ImageCropperImplementation() })
        
        // ViewModels
        container.register(HotelsViewModeling.self) { (resolver) -> HotelsViewModeling in
            let networkService = resolver.resolve(NetworkingService.self)!
            let database = resolver.resolve(Database.self)!
            return HotelsViewModel(database: database, networkingService: networkService)
        }
        
        container.register(HotelInfoViewModeling.self) { (resolver, hotelId: Int) -> HotelInfoViewModeling in
            let networkService = resolver.resolve(NetworkingService.self)!
            let database = resolver.resolve(Database.self)!
            let dataManager = resolver.resolve(DataManager.self)!
            let imageCropper = resolver.resolve(ImageCropper.self)!
            return HotelInfoViewModel(hotelId: hotelId, database: database, networkingService: networkService, dataManager: dataManager, imageCropper: imageCropper)
        }
        
        // Views
        container.register(HotelsViewController.self) { (resolver) -> HotelsViewController in
            let viewController = UIStoryboard(name: String(describing: HotelsViewController.self), bundle: nil).instantiateInitialViewController() as! HotelsViewController
            viewController.viewModel = resolver.resolve(HotelsViewModeling.self)!
            return viewController
        }
        
        container.register(HotelInfoViewController.self) { (resolver, hotelId: Int) -> HotelInfoViewController in
            let viewController = UIStoryboard(name: String(describing: HotelInfoViewController.self), bundle: nil).instantiateInitialViewController() as! HotelInfoViewController
            viewController.viewModel = resolver.resolve(HotelInfoViewModeling.self, argument: hotelId)!
            return viewController
        }
        
        container.register(MapViewController.self) { (resolver, location: (Double, Double)) -> MapViewController in
            let viewController = UIStoryboard(name: String(describing: MapViewController.self), bundle: nil).instantiateInitialViewController() as! MapViewController
            viewController.location = location
            return viewController
        }
        
        return container
    }()
    
}
