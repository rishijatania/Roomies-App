//
//  UserInfoTableViewCell.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/22/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameTF: UILabel!
    @IBOutlet weak var roleTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellView.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView() {
        NSLayoutConstraint.activate([
            self.cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.cellView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.cellView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.cellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
    }
    
}
