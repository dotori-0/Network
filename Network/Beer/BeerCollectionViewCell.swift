//
//  BeerCollectionViewCell.swift
//  Network
//
//  Created by SC on 2022/08/02.
//

import UIKit

import Kingfisher


class BeerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    
    let defaultImageURL = "https://cdn-icons.flaticon.com/png/512/2977/premium/2977173.png?token=exp=1659369480~hmac=95a5a73c533cc76f4b3dabfebe8cb3e4"
    
    
    func configureCell() {
        let url = URL(string: defaultImageURL)
        beerImageView.kf.setImage(with: url)
        
        beerNameLabel.text = "Beer Name"
    }
}
