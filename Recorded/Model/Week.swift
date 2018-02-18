//
//  Week.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

struct Week: Codable {
    var days: [Day] // days in order from newest saturday to oldest sunday

    func getFormattedDateRangeString() -> String {
        let dateString = "\(self.days[6].date.toFormattedString()) - \(self.days[0].date.toFormattedString())"
        return dateString
    }
}
