//
//  ImageCropper.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ImageCropper {
    func cropImageBorder(for imageData: Data, borderWidth: Int) -> Observable<Data>
}

struct ImageCropperImplementation: ImageCropper {
    
    func cropImageBorder(for imageData: Data, borderWidth: Int) -> Observable<Data> {
        return Observable.create { (observer) -> Disposable in
            
            if let cgimage = UIImage(data: imageData)?.cgImage {
                
                let newOrigin = CGPoint(x: borderWidth, y: borderWidth)
                let newSize = CGSize(width: cgimage.width - borderWidth * 2,
                                     height: cgimage.height - borderWidth * 2)
                
                if let cutImageRef = cgimage.cropping(to: CGRect(origin: newOrigin, size: newSize)) {
                    
                    let croppedImageData = UIImage(cgImage: cutImageRef).jpegData(compressionQuality: 1.0)!
                    
                    observer.onNext(croppedImageData)
                    
                } else {
                    observer.onNext(imageData)
                }
                
            } else {
                observer.onNext(imageData)
            }
            
            return Disposables.create {}
        }
    }
    
}
