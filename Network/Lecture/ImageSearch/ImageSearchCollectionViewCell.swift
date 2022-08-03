//
//  ImageSearchCollectionViewCell.swift
//  Network
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Kingfisher

class ImageSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    
    func configureCell(data: ImageModel) {
        let url = URL(string: data.thumbnail)
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        
        imageTitleLabel.text = data.title
        
        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 10.0
//        layer.shadowOpacity = 1.0
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10.0
        contentView.layer.shadowOpacity = 0.7
//        contentView.layer.masksToBounds = true
        layer.masksToBounds = false
//        print("clipsToBounds", clipsToBounds)
//        print(layer.masksToBounds)
    }
}
