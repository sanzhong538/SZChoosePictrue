//
//  SZImage.swift
//  SZChoosePictrue
//
//  Created by 吴三忠 on 16/6/21.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

import UIKit

class SZImage: UIImage {
    
    func clipImageWithImage(image: UIImage) -> UIImage {
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let minSize = min(imageWidth, imageHeight)
        let newRect: CGRect = CGRect(x: 0, y: 0, width: minSize, height: minSize)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, newRect)
        UIGraphicsBeginImageContext(newRect.size)
        let ref = UIGraphicsGetCurrentContext()
        CGContextDrawImage(ref, newRect, imageRef)
        let newImage = UIImage(CGImage: imageRef!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func clipImageWithImage(image: UIImage, count: Int) -> [UIImage] {
        
        var imageArray = [UIImage]()
        let imageSize = image.size.width
        let newImageWidth: CGFloat = imageSize / CGFloat(count)
        
        for i in 0..<count {
            for j in 0..<count {
                let newImageRect = CGRect(x: CGFloat(j) * newImageWidth, y:CGFloat(i) * newImageWidth, width: newImageWidth, height: newImageWidth)
                let ref = UIGraphicsGetCurrentContext()
                let imageRef = CGImageCreateWithImageInRect(image.CGImage, newImageRect)
                UIGraphicsBeginImageContext(newImageRect.size)
                CGContextDrawImage(ref, newImageRect, imageRef)
                let newImage = UIImage(CGImage: imageRef!)
                UIGraphicsEndImageContext()
                imageArray.append(newImage)
            }
        }
        return imageArray
    }
}
