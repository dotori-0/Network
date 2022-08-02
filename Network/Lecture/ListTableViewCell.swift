//
//  SearchTableViewCell.swift
//  Network
//
//  Created by SC on 2022/07/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
//    static let identifier = "ListTableViewCell"

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var showCountLabel: UILabel!
    
    func designLabels() {
        rankLabel.font = .boldSystemFont(ofSize: 20)
        rankLabel.textAlignment = .center
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        releaseDateLabel.font = .systemFont(ofSize: 11)
        totalCountLabel.textAlignment = .center
        
        totalCountLabel.font = .systemFont(ofSize: 11)
        totalCountLabel.textAlignment = .right
        
        showCountLabel.font = .systemFont(ofSize: 11)
        showCountLabel.textAlignment = .right
    }
    
    func updateLabelTexts(data: BoxOfficeModel) {
        rankLabel.text = data.rank
        titleLabel.text = data.movieTitle
        releaseDateLabel.text = data.releaseDate
        totalCountLabel.text = data.totalCount
        showCountLabel.text = data.showCount
    }
}
