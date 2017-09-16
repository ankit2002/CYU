//
//  UploadDocTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 05/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class UploadDocTableViewCell: UITableViewCell {
    
    // identifier "UploadDocCell" data for table view cell to be used further

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
