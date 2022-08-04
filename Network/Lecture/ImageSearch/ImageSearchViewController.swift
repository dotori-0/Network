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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageModels: [ImageModel] = []
    
    let spacing: CGFloat = UIScreen.main.bounds.width * 0.04
    let horizontalInset: CGFloat = 20
    
    // 네트워크 요청할 시작 페이지 넘버
    var startPage = 1
    var totalCount = 0
    
//    let hud = JGProgressHUD()  // Module
//    let hudd = JGProgressHUD()  // Class
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self  // 페이지네이션
        
        imageCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        configureCollectionViewLayout()
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
    func fetchImage(query: String) {
        print("fetchImage starting")
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 옵셔널이기 때문에 타입 어노테이션이나 가드구문 등으로 처리
        let url = Endpoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"  // 왜 한글만 안 될까?
        
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200...500).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    print("typeOfValue: \(type(of: value))")
                    print("typeOfjson: \(type(of: json))")
                    
                    self.totalCount = json["total"].intValue
                    
                    for item in json["items"].arrayValue {
//                        print(item["title"])  // .stringValue 하지 않아도 되는 이유?
                        
                        // 셀에서 URL, UIImage 변환을 할 건지
                        // 서버통신 받는 시점에서 URL, UIImage 변환을 할 건지 -> 시간 오래 걸릴 수 있음
                        
                        // 예) 총 20개 셀, 한 번에 보이는 셀이 3-4개이면
                        // 여기에서 변환하면 보지도 않은 셀의 이미지까지 처리하는 상황이 생긴다 ☘️
                        // 데이터를 받아서 다른 조작/처리를 하는 것을 서버통신할 때 하지는 않는다
                        
                        let title = item["title"].stringValue
                        let thumbnail = item["thumbnail"].stringValue
                        let sizeHeight = item["sizeheight"].stringValue
                        let sizeWidth = item["sizewidth"].stringValue

                        let imageModel = ImageModel(title: title, thumbnail: thumbnail, sizeHeight: sizeHeight, sizeWidth: sizeWidth)
                        
                        self.imageModels.append(imageModel)
//                        print(self.imageModels)
//                        print(self.imageModels.count)
                        
                        self.imageCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchImage ending")
    }
}


extension ImageSearchViewController: UISearchBarDelegate {
    // 검색 버튼 클릭 시 실행 (키보드 리턴 키에 디폴트로 기능 내장)
    // 검색어가 바뀔 수 있음 5
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            imageModels.removeAll()
            startPage = 1
            
//            imageCollectionView.scrollsToTop = true
            
            fetchImage(query: text)
        }
    }
    
    // 취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageModels.removeAll()
        imageCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }

    // 서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}


// 페이지네이션 방법 3.
// 용량이 큰 이미지를 다운받아 셀에 보여 주려고 하는 경우에 효과적
// 셀이 화면에 보이기 전에 미리 필요한 리소스를 다운 받을 수도 있고, 필요하지 않다면 데이터를 취소할 수도 있음
// iOS 10 이상, 스크롤 성능 향상됨 ☘️
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageModels.count - 1 == indexPath.item && imageModels.count < totalCount {
                startPage += 30
                fetchImage(query: searchBar.text!)
            }
        }
        
        print("===\(indexPaths)===")
    }
    
    // 작업 취소: 직접 취소하는 기능을 구현해야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)===")
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
        
//        print(indexPath.item)
//        print(imageModels[indexPath.item].sizeHeight)
        cell.configureCell(data: imageModels[indexPath.item])
        
        return cell
    }
    
    // 페이지네이션 방법 1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막 셀에 사용자가 위치해있는지 명확하게 확인하기가 어려움
    // 
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // 페이지네이션 방법 2. UIScrollViewDelegateProtocol
    // 테이블뷰/컬렉션뷰는 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있음
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)  // 사용자가 얼마나 내려왔는지 확인할 수 있다
//    }
    
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
