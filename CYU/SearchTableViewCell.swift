//
//  SearchTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 13/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var rowName: UILabel!
    @IBOutlet weak var wishlistbutton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
