//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Azar Aliyev on 5/20/24.
//  Copyright © 2024 Azar Aliyev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bubbleView.layer.cornerRadius = bubbleView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
