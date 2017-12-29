//
//  AboutTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item : ProfileModelItem? {
        didSet{
            guard let item = item as? ProfileViewModelAbout else {
                return
            }
            
            self.aboutLbl.text = item.about
            
        }
    }
    
    
    static var identifier: String{
        return String (describing: self)
    }
    
    static var nib : UINib{
        return UINib (nibName: identifier, bundle: nil)
    }
    
}
