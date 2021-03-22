//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Deven Day on 3/22/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    //MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
    
}//END OF CLASS
