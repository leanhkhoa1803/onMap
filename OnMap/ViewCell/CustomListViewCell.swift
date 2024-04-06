//
//  CustomListViewCell.swift
//  OnMap
//
//  Created by KhoaLA8 on 4/4/24.
//

import Foundation
import UIKit

class CustomListViewCell : UITableViewCell{
    @IBOutlet weak var customTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
