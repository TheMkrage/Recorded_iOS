//
//  PaperTextView.swift
//  Recorded
//
//  Created by Matthew Krager on 2/18/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class PaperTextView: UITextView {
    var lineHeight: CGFloat = 18.8
    
    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        let numberOfLines = Int(rect.height / lineHeight)
        let topInset = textContainerInset.top
        
        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight
            
            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            ctx?.setLineWidth(0.25)
            ctx?.addPath(line)
        }
        
        ctx?.strokePath()
        
        super.draw(rect)
    }
}
