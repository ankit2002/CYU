//
//  CustomRoundButton.swift
//  CYU
//
//  Created by Ankit Mishra on 04/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

@IBDesignable class CustomRoundButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    @IBInspectable var rounded : Bool = false{
        didSet{
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
