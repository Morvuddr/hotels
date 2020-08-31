//
//  DataManager.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import RxSwift

protocol DataManager {
    func save(data: Data, forKey key: String)
    func loadData(forKey key: String) -> Observable<Data?>
}

struct DataManagerImplementation: DataManager {
    
    func save(data: Data, forKey key: String) {
        if let filePath = self.filePath(forKey: key),
            !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try data.write(to: filePath, options: .atomic)
            } catch let err {
                print("Saving results in error: ", err)
            }
        }
    }
    
    func loadData(forKey key: String) -> Observable<Data?> {
        guard let filePath = self.filePath(forKey: key) else { return Observable.just(nil) }
        return Observable.create { (observer) -> Disposable in
            let fileData = FileManager.default.contents(atPath: filePath.path)
            observer.on(.next(fileData))
            return Disposables.create { }
        }
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {
                                                    return nil
        }
        
        return documentURL.appendingPathComponent(key + ".jpg")
    }
    
}
