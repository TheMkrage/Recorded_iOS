//
//  DayTableViewCell.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    @IBOutlet weak var widthImage: NSLayoutConstraint!
    
    @IBOutlet weak var cloudImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
