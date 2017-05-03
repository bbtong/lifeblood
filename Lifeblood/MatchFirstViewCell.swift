//
//  MatchFirstViewCell.swift
//  Lifeblood
//
//  Created by Bryan Tong on 5/2/17.
//  Copyright © 2017 btong. All rights reserved.
//

import Foundation
import UIKit

class MatchFirstViewCell: UITableViewCell {
    
    @IBOutlet weak var nameAndLocation: UILabel!
    
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
