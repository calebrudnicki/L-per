//
//  RunDataCell.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/18/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class RunDataCell: UITableViewCell {

//MARK: Outlets
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
//MARK: Boilerplate Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}