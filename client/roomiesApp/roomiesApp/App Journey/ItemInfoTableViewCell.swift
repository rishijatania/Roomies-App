//
//  ItemInfoTableViewCell.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class ItemInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNamelbl: UILabel!
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var boughtBylbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellView.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView() {
        
        NSLayoutConstraint.activate([
            self.cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.cellView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.cellView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.cellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
    }
}
