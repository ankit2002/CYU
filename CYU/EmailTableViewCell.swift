//
//  EmailTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class EmailTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
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
            guard let item = item as? ProfileViewModelEmail else{
                return
            }
            
            self.emailLbl.text = item.email
            
        }
    }
    
    static var identifier : String{
        return String (describing: self)
    }
    
    static var nib : UINib {
        return UINib (nibName: identifier, bundle: nil)
    }
    
}
