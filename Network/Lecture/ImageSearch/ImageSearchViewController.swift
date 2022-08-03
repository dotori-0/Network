//
//  ImageSearchViewController.swift
//  Network
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


class ImageSearchViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageModels: [ImageModel] = []
    
    let spacing: CGFloat = UIScreen.main.bounds.width * 0.04
    let horizontalInset: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        configureCollectionViewLayout()
        
        fetchImage()
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
//        let spacing: CGFloat = UIScreen.main.bounds.width * 0.02
//        let horizontalSpacing: CGFloat = 20
        
        layout.sectionInset = UIEdgeInsets(top: 30, left: horizontalInset, bottom: 30, right: horizontalInset)
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = spacing
        
//        let width = UIScreen.main.bounds.width - (horizontalInset * 2) - (spacing * 1)  // 모든 여백 제외한 너비
//        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.2)
        
        imageCollectionView.collectionViewLayout = layout
    }
    
    // fetch, request, callRequest, get,... > response에 따라 네이밍을 하기도 한다 > 언제 뭘 쓰는지 찾아보기
    // 내일 > 페이지네이션
    func fetchImage() {
        print("fetchImage starting")
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 옵셔널이기 때문에 타입 어노테이션이나 가드구문 등으로 처리
        let url = Endpoint.imageSearchURL + "query=\(text)&display=30&start=25"  // 왜 한글만 안 될까?
        
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    for item in json["items"].arrayValue {
//                        print(item["title"])  // .stringValue 하지 않아도 되는 이유?
                        
                        let title = item["title"].stringValue
                        let thumbnail = item["thumbnail"].stringValue
                        let sizeHeight = item["sizeheight"].stringValue
                        let sizeWidth = item["sizewidth"].stringValue

                        let imageModel = ImageModel(title: title, thumbnail: thumbnail, sizeHeight: sizeHeight, sizeWidth: sizeWidth)
                        
                        self.imageModels.append(imageModel)
//                        print(self.imageModels)
                        print(self.imageModels.count)
                        
                        self.imageCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchImage ending")
    }

}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 30  // cellForItemAt 함수에서 index out of range 에러
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            print("Cannot find ImageSearchCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 1.0
        
        print(indexPath.item)
        print(imageModels[indexPath.item].sizeHeight)
        cell.configureCell(data: imageModels[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = UIScreen.main.bounds.width - (horizontalInset * 2) - (spacing * 1)   // 모든 여백 제외한 너비
        let width = totalWidth / 2
        var height: CGFloat

        let jsonWidth = Double(imageModels[indexPath.item].sizeWidth) ?? width
        let jsonHeight = Double(imageModels[indexPath.item].sizeHeight) ?? width

        height = jsonHeight * width / jsonWidth

        let itemSize = CGSize(width: width, height: height + 20)

        return itemSize
    }
}
