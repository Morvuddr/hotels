//
//  ObservableType+filterErrors.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import RxSwift

extension ObservableType {
    func filterErrors() -> RxSwift.Observable<Self.Element> {
        return self.materialize()
            .filter {
                guard $0.error == nil else {
                    print($0.error!)
                    return false
                }
                
                return true
        }
        .dematerialize()
    }
}
