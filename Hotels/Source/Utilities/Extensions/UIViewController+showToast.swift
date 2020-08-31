//
//  UIViewController+showToast.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, font: UIFont = .systemFont(ofSize: 16), toastColor: UIColor = UIColor.white,
                   toastBackground: UIColor = UIColor.black) {
        guard self.view.viewWithTag(765) == nil else { return }
        
        let toastLabel = UILabel()
        toastLabel.tag = 765
        toastLabel.textColor = toastColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 6
        toastLabel.numberOfLines = 1
        toastLabel.backgroundColor = toastBackground

        toastLabel.clipsToBounds  =  true

        let toastWidth: CGFloat = self.view.frame.width - 32
        let toastHeight: CGFloat = toastLabel.intrinsicContentSize.height + 8
        
        toastLabel.frame = CGRect(x: self.view.frame.width / 2 - (toastWidth / 2),
                                  y: self.view.frame.height - (toastHeight * 3),
                                  width: toastWidth, height: toastHeight)
        
        self.view.addSubview(toastLabel)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
