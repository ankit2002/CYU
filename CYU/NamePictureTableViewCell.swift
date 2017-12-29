//
//  NamePictureTableViewCell.swift
//  CYU
//
//  Created by Ankit Mishra on 02/10/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

class NamePictureTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage?.layer.cornerRadius = 50
        profileImage?.clipsToBounds = true
        profileImage?.contentMode = .scaleAspectFit
        profileImage?.backgroundColor = UIColor.lightGray
        
    }

    
    var item : ProfileModelItem? {
        didSet{
            guard let item = item as? ProfileViewModelNameAndPicture else {
                return
            }
            nameLbl.text = item.name
            profileImage.image = UIImage (named: item.picUrl)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String (describing: self)
    }
    
    static var nib : UINib {
        return UINib (nibName: identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    
}
