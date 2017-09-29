//
//  ShowAppliedUniTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 28/09/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class ShowAppliedUniTableViewCell: UITableViewCell {

    @IBOutlet weak var uniName: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
