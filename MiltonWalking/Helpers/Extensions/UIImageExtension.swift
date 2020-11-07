//
//  UIImageExtension.swift
//  LockPic
//
//  Created by Krishna Datt Shukla on 01/02/19.
//  Copyright © 2019 Appzoro. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func getThumbnailFrom(gif: String) -> UIImage? {
       
        
        if let data = NSData(contentsOfFile: gif) {
            
            let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)
            let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.length) 

            guard let source = CGImageSourceCreateWithData(cfData!, nil) else {
                print("Source for the image does not exist")
                return nil
            }
            let count = CGImageSourceGetCount(source)
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let image = UIImage(cgImage: cgImage)
                    return image
                }
            }
        }
       
        return nil
    }
    
    
    class func getImagesFromGIF(asset: String) -> [UIImage]? {
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            print("Source for the image does not exist")
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        return images
    }
}
