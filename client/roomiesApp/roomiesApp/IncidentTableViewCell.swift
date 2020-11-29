//
//  IncidentTableViewCell.swift
//  safe_campus
//
//  Created by Karan Racca on 4/23/19.
//  Copyright © 2019 Karan Racca. All rights reserved.
//

import UIKit

class IncidentTableViewCell: UITableViewCell {

    @IBOutlet weak var incidentCodeGroup: UILabel!
    @IBOutlet weak var streetZip: UILabel!
    @IBOutlet weak var verified: UILabel!
    @IBOutlet weak var incidentDesc: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var incidentImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        incidentDesc.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
