//
//  HeaderTableViewCell.swift
//  Network
//
//  Created by SC on 2022/08/02.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var rankHeaderLabel: UILabel!
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var releaseDateHeaderLabel: UILabel!
    @IBOutlet weak var totalCountHeaderLabel: UILabel!
    @IBOutlet weak var showCountHeaderLabel: UILabel!
    
    func designLabels() {
        rankHeaderLabel.textAlignment = .center
        rankHeaderLabel.font = .boldSystemFont(ofSize: 13)
        
        titleHeaderLabel.textAlignment = .center
        titleHeaderLabel.font = .boldSystemFont(ofSize: 13)
        
        releaseDateHeaderLabel.textAlignment = .center
        releaseDateHeaderLabel.font = .systemFont(ofSize: 10)
        
        totalCountHeaderLabel.textAlignment = .right
        totalCountHeaderLabel.font = .systemFont(ofSize: 10)
        
        showCountHeaderLabel.textAlignment = .right
        showCountHeaderLabel.font = .systemFont(ofSize: 10)
    }
}
