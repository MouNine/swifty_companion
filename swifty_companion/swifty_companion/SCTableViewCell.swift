//
//  SCTableViewCell.swift
//  swifty_companion
//
//  Created by Emmanuelle BOEUF on 1/27/16.
//  Copyright © 2016 Emmanuelle BOEUF. All rights reserved.
//

import UIKit

class SCTableViewCell: UITableViewCell {

    @IBOutlet weak var nameProjects: UILabel!
    @IBOutlet weak var finalMark: UILabel!
    @IBOutlet weak var nameSkills: UILabel!
    @IBOutlet weak var progressSkills: UIProgressView!
    @IBOutlet weak var levelPercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
