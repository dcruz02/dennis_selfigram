//
//  selfieCellTableViewCell.swift
//  Selfigram
//
//  Created by Dennis Cruz on 2018-07-18.
//  Copyright © 2018 Dennis Cruz. All rights reserved.
//

import UIKit

class selfieCellTableViewCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
