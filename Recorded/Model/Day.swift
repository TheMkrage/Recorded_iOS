//
//  Day.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

extension UIImage {
    func toBase64() -> String {
        let image = self
        guard let imgData = UIImageJPEGRepresentation(image, 0.2) else {
            return ""
        }
        return imgData.base64EncodedString()
    }
    
    func giveTransparentBackground() -> UIImage {
        var image = UIImage(data: UIImageJPEGRepresentation(self, 1.0)!)!
        let rawImageRef: CGImage = image.cgImage!
        
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size);
        
        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: image.size.height)
        UIGraphicsGetCurrentContext()!.translateBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsGetCurrentContext()!.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return result!
    }
}

struct Day: Codable {
    var cloudImageBase64: String
    var date: Date
    var text: String
    var width: Double
    var height: Double
    
    func getCloudImage() -> UIImage? {
        let data = Data.init(base64Encoded: self.cloudImageBase64)
        var image: UIImage!
        if self.cloudImageBase64 == "" {
            image = #imageLiteral(resourceName: "Screen Shot 2018-02-18 at 4.11.35 AM")
        } else {
            image = UIImage(data: data!)!
        }
        return image
    }
}
