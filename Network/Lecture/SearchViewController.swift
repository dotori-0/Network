//
//  SearchViewController.swift
//  Network
//
//  Created by SC on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔  // 🕘 2:35:00
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

/*
 각 json value -> list에 넣기 -> 테이블 뷰 갱신
 서버의 응답이 몇 개일지 모를 경우에는?
 */


extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = .red
    }
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!  // SearchBar는 액션 없음
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var second: UITableView!
    @IBOutlet weak var third: UITableView!
    
    // BoxOffice 배열
//    var list: [String] = []
    var list: [BoxOfficeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰에 delegate와 dataSource 연결
        // 연결고리 작업: 테이블뷰가 해야할 역할 > 뷰컨트롤러에게 요청
        searchTableView.delegate = self  // self: SearchViewController의 인스턴스
        searchTableView.dataSource = self
        
        // 테이블뷰가 사용할 테이블뷰 셀 등록
        // XIB: Xml Interface Builder <= 예전에는 Nib이라는 파일을 사용했음
        searchTableView.register(UINib(nibName: ListTableViewCell.resueIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.resueIdentifier)
        
        searchBar.delegate = self
        
        requestBoxOffice(text: "20220801")
    }
    
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func configureLabel(text: String) {
        return
    }
    
    func requestBoxOffice(text: String) {
        
        list.removeAll()  // 첫 번째 방법  // 로딩바를 띄워 준다면 받아오는구나 할 수 있다
        // 검색하면 다 지우는 게 더 나은 방법일 수 있다
        
        // AF: 200~299 status code - success
        // 인증키: 박스오피스의 경우 3000회 제한
        let url = "\(Endpoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"  // ?나 & 등이 중복되지 않도록 주의!
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in  // Alamofire에서 AF로 바뀜
            switch response.result {
                case .success(let value):
                    print("==3==")
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
//                    self.list.removeAll()  // 두 번째 방법  // 둘 중 뭐가 더 낫다고 하기 어렵다
                    
                    for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                        let movieNm = movie["movieNm"].stringValue
                        let openDt = movie["openDt"].stringValue
                        let audiChange = movie["audiChange"].stringValue
                        let rank = movie["rank"].stringValue
                        
                        let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiChange, rank: rank)
                        
                        self.list.append(data)
                    }
                    
//                    let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                    let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                    let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                    // list 배열에 데이터 추가
//                    self.list.append(movieNm1)
//                    self.list.append(movieNm2)
//                    self.list.append(movieNm3)
                    
                    print(self.list)
                    
                    // 테이블뷰 갱신
                    self.searchTableView.reloadData()
                    
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            Method does not override any method from its superclass
//      UITableViewController 라면 재정의가 맞지만, UIViewController 상속이기 때문에 재정의 X
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.resueIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"
        
        return cell
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        requestBoxOffice(text: searchBar.text!)  // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인지 등 확인 필요
        requestBoxOffice(text: searchBar.text!)
    }
}
