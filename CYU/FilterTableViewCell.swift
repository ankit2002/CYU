//
//  FilterTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 18/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterType: UILabel!
    @IBOutlet weak var filterSelectedValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
