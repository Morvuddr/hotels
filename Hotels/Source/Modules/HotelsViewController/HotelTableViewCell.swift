//
//  HotelTableViewCell.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Outlets
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var availableRoomsLabel: UILabel!
    
    // MARK: - Methods
    func configure(withViewModel viewModel: HotelTableViewCellModeling) {
        starsLabel.text = viewModel.stars
        hotelNameLabel.text = viewModel.hotelName
        hotelAddressLabel.text = viewModel.address
        availableRoomsLabel.text = viewModel.availableRooms
    }
    
}
