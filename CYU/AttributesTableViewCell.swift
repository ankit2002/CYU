//
//  AttributesTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class AttributesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var valueData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item : Attributes? {
        didSet{
            titleName.text = item?.key
            valueData.text = item?.value
        }
    }
    
    static var identifier : String{
        return String (describing: self)
    }
    
    static var nib : UINib {
        return UINib (nibName: identifier, bundle: nil)
    }
    
}
