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
    
    func getCloudImage() -> UIImage? {
        guard self.cloudImageBase64 != "", let data = Data.init(base64Encoded: self.cloudImageBase64) else {
            return nil
        }
        return UIImage(data: data)
    }
}
