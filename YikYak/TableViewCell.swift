//
//  TableViewCell.swift
//  YikYak
//
//  Created by Shrikar Archak on 12/29/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class TableViewCell: PFTableViewCell {

    @IBOutlet weak var yakText: UILabel!
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replies: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
