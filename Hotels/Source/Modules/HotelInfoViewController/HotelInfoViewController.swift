//
//  HotelInfoViewController.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import Swinject

final class HotelInfoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var availableRoomsLabel: UILabel!
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    var viewModel: HotelInfoViewModeling!
    
    // Private
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHotelAddressLabel()
        configureNavigationItem()
        bindToViewModel()
    }
    
    // MARK: - Methods
    private func configureNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: false)
    }
    
    private func configureHotelAddressLabel() {
        let tapGesture = UITapGestureRecognizer()
        hotelAddressLabel.addGestureRecognizer(tapGesture)
        hotelAddressLabel.isUserInteractionEnabled = true
    }
    
    private func bindToViewModel() {
        
        hotelAddressLabel.gestureRecognizers?.first?.rx.event
            .asObservable()
            .map({ _ in })
            .bind(to: viewModel.locationTapped)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .bind(to: self.viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.hotelImageData
            .map{ UIImage(data: $0) }
            .drive(self.hotelImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.hotelName
            .drive(self.hotelNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hotelAddress
            .drive(self.hotelAddressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hotelStars
            .drive(self.starsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hotelRooms
            .drive(self.availableRoomsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loading
            .drive(onNext: {  [weak self] (value) in
                value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] error in
                self?.activityIndicator.stopAnimating()
                self?.showToast(message: error.message, toastColor: .white, toastBackground: .red)
            })
            .disposed(by: disposeBag)
        
        viewModel.showMap
            .drive(onNext: { [weak self] (lat, lon) in
                self?.showMap(location: (lat, lon))
            })
            .disposed(by: disposeBag)
    }
    
    private func showMap(location: (Double, Double)) {
        guard let viewController = Container.sharedContainer.resolve(MapViewController.self, argument: location) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
