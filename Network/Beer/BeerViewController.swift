//
//  BeerViewController.swift
//  Network
//
//  Created by SC on 2022/08/02.
//

import UIKit

class BeerViewController: UIViewController {

    @IBOutlet weak var beerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beerCollectionView.register(UINib(nibName: BeerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BeerCollectionViewCell.reuseIdentifier)
        
        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        configureCollectionViewLayout()
    }
    
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let horizontalSpacing: CGFloat = 20
        
        layout.sectionInset = UIEdgeInsets(top: 30, left: horizontalSpacing, bottom: 30, right: horizontalSpacing)
        layout.minimumLineSpacing = spacing * 3
        layout.minimumInteritemSpacing = spacing
        
        let width = UIScreen.main.bounds.width - (horizontalSpacing * 2) - (spacing * 1)  // 모든 여백 제외한 너비
        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.2)
        
        beerCollectionView.collectionViewLayout = layout
    }
    
}


extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.reuseIdentifier, for: indexPath) as? BeerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell()
        
        return cell
    }
    
    
}
