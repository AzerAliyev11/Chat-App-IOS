//
//  MyMessageCell.swift
//  Flash Chat iOS13
//
//  Created by Azar Aliyev on 5/23/24.
//  Copyright © 2024 Azar Aliyev. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var replyNameLabel: UILabel!
    @IBOutlet weak var replyMessageLabel: UILabel!
    @IBOutlet weak var replyView: UIView!
    
    func withoutReplySetup() {
        replyNameLabel.text = ""
        replyMessageLabel.text = ""
        replyView.isHidden = true
    }
    
    func withReplySetup(replyName: String, replyMessage: String) {
        replyNameLabel.text = replyName
        replyMessageLabel.text = replyMessage
        replyView.isHidden = false
    }
    
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
