//
//  Day.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

struct Day: Codable {
    var cloudImageBase64: String
    var date: Date
    var text: String
    var width: Double
    var height: Double
    
    func getCloudImage() -> UIImage? {
        guard self.cloudImageBase64 != "", let data = Data.init(base64Encoded: self.cloudImageBase64) else {
            return nil
        }
        var image = UIImage(data: data)!
        image = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!)!
        let rawImageRef: CGImage = image.cgImage!
        
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size);
        
        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: image.size.height)
        UIGraphicsGetCurrentContext()!.translateBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsGetCurrentContext()!.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
       return result!
    }
}
