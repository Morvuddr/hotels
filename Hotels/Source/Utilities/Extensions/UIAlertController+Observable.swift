
//
//  UIAlertController+Observable.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit
import RxSwift

extension UIAlertController {

    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style
        var checked: Bool

        static func action(title: String?, style: UIAlertAction.Style = .default, checked: Bool = false) -> AlertAction {
            return AlertAction(title: title, style: style, checked: checked)
        }
    }

    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            actions.enumerated().forEach { index, customAction in
                let action = UIAlertAction(title: customAction.title, style: customAction.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                action.setValue(customAction.checked, forKey: "checked")
                alertController.addAction(action)
            }
            
            // Removing warnings
            alertController.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint)-> (Bool)  in
              return (one.constant < 0) && (one.secondItem == nil) &&  (one.firstAttribute == .width)
            }.first?.isActive = false

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }

    }

}
