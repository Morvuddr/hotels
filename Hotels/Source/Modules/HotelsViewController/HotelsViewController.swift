//
//  HotelsViewController.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Swinject

class HotelsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = UIActivityIndicatorView()
    private let sortButton = UIButton()
    
    // MARK: - Properties
    var viewModel: HotelsViewModeling!
    
    // Private
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        bindViewModel()
    }
    
    // MARK: - Methods
    
    private func configureNavigationItem() {
        
        sortButton.setImage(UIImage(named: Images.sort), for: .normal)
        sortButton.isHidden = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3.0
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(sortButton)
        
        navigationItem.setRightBarButton(UIBarButtonItem(customView: stackView), animated: false)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func bindViewModel() {
        
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .asObservable()
            .withLatestFrom(viewModel.selectedSort)
            .flatMap({ [weak self] sorting -> Observable<Int> in
                guard let sself = self else { return Observable.empty() }
                var actions: [UIAlertController.AlertAction] = [
                    .action(title: Messages.withoutSorting),
                    .action(title: Messages.byNumberOfRooms),
                    .action(title: Messages.byDistance)
                ]
                actions[sorting.rawValue].checked = true
                
                return UIAlertController.present(in: sself, title: Messages.chooseSorting, message: nil, style: .actionSheet, actions: actions)
            })
            .compactMap({ Sorting(rawValue: $0) })
            .bind(to: viewModel.selectedSort)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .bind(to: viewModel.selectedIndexPath)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.async { // Removing warnings
            self.viewModel.hotels
                .do(onNext: { [weak self] hotels in
                    self?.sortButton.isHidden = hotels.isEmpty
                })
                .drive(self.tableView.rx.items(cellIdentifier: HotelTableViewCell.reuseIdentifier, cellType: HotelTableViewCell.self))
                { (row, cellViewModel, cell) in
                    cell.configure(withViewModel: cellViewModel)
                }
            .disposed(by: self.disposeBag)
        }
        
        viewModel.loading
            .drive(onNext: {  [weak self] (value) in
                value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        
        viewModel.selectedHotelId
            .drive(onNext: { [weak self] id in
                self?.showHotelInfoViewController(hotelId: id)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] error in
                self?.activityIndicator.stopAnimating()
                self?.showToast(message: error.message, toastColor: .white, toastBackground: .red)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showHotelInfoViewController(hotelId: Int) {
        guard let viewController = Container.sharedContainer.resolve(HotelInfoViewController.self, argument: hotelId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
