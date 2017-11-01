//
//  NewDeviceTableViewCell.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit

class NewDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var newDevicesImage: UIImageView!
    @IBOutlet weak var newDeviceLab: UILabel!
    @IBOutlet weak var newDeviceId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
