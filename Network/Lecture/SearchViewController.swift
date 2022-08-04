//
//  SearchViewController.swift
//  Network
//
//  Created by SC on 2022/07/27.
//

import UIKit

import Alamofire
import JGProgressHUD
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
    
    // 타입 어노테이션 vs 타입 추론 -> 누가 속도가 더 빠를까?
    // WWDC - What's new in Swift: 타입추론 알고리즘 개선
    var nickname: String = ""
    var username = ""
    
    let hud = JGProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰에 delegate와 dataSource 연결
        // 연결고리 작업: 테이블뷰가 해야할 역할 > 뷰컨트롤러에게 요청
        searchTableView.delegate = self  // self: SearchViewController의 인스턴스
        searchTableView.dataSource = self
        
        // 테이블뷰가 사용할 테이블뷰 셀 등록
        // XIB: Xml Interface Builder <= 예전에는 Nib이라는 파일을 사용했음
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        searchTableView.register(UINib(nibName: HeaderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        
        searchBar.delegate = self
        searchBar.keyboardType = .numberPad
        
        // Date, DateFormatter, Calendar 찾아보기
        // Calendar는 국가별/사용자가 있는 지역에 대응하기 때문에 Calendar를 권장한다
        // 사용자의 여러 국가나 지역별 상황에서 달라질 수 있는 날짜 타입들을 명확한 형태로 연산
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"  // TMI - "yyyyMMdd" "YYYYMMdd" 차이점 찾아보기 - 마지막주는 2023년이 될 것
//        let dateResult = Date(timeIntervalSinceNow: -86400)
        
        // Calendar 활용
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateResult = format.string(from: yesterday!)
        
        // 네트워크 통신: 서버 점검 등에 대한 예외 처리
        // 네트워크가 느린 환경 테스트: 실기기 테스트 시 Condition 조절 가능!
        // 시뮬레이터에서도 가능! (추가 설치 필요)(권장하지는 않음, 실기기 권장)
        
        
//        requestBoxOffice(text: "20220801")
        requestBoxOffice(text: dateResult)  // 실행한 날의 하루 전 날
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
        hud.show(in: view)
        
        print("requestBoxOffice starting")
        list.removeAll()  // 첫 번째 방법  // 로딩바를 띄워 준다면 받아오는구나 할 수 있다
        // 검색하면 다 지우는 게 더 나은 방법일 수 있다
        
        // AF: 200~299 status code - success
        // 인증키: 박스오피스의 경우 3000회 제한
        let url = "\(Endpoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"  // ?나 & 등이 중복되지 않도록 주의!
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in  // Alamofire에서 AF로 바뀜
            switch response.result {
                case .success(let value):
                    print("==3==")
                    let json = JSON(value)
                    print("value: \(value)")
                    print(type(of: value))
//                    print("JSON: \(json)")
                    
//                    self.list.removeAll()  // 두 번째 방법  // 둘 중 뭐가 더 낫다고 하기 어렵다
                    
                    for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                        let rank = movie["rank"].stringValue  // 순위
                        let movieNm = movie["movieNm"].stringValue  // 영화 이름
                        let openDt = movie["openDt"].stringValue  // 개봉일
                        let audiAcc = movie["audiAcc"].stringValue  // 누적관객수
                        let showCnt = movie["showCnt"].stringValue  // 해당 일자 상영 횟수

                        let data = BoxOfficeModel(rank: rank, movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc, showCount: showCnt)
                        
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
                    self.hud.dismiss(animated: true)
                    
                    
                case .failure(let error):
                    self.hud.dismiss()  // 네트워크 실패해도 없애 주어야 함
                    
                    print(error)
                    
                    // 시뮬레이터 네트워크 > 맥의 네트워크와 연결이 되어 있다
                    // 시뮬 네트워크 실패 테스트 > 맥 와이파이 끄면 안 됨!
            }
        }
//        self.hud.dismiss()  // 이 위치는? 네트워크 통신이 끝나지 않아도 실행되기 때문에 바로 사라져 버린다!
    }
    
    
    // MARK: - Table View Configuration

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            Method does not override any method from its superclass
//      UITableViewController 라면 재정의가 맞지만, UIViewController 상속이기 때문에 재정의 X
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseIdentifier, for: indexPath) as? HeaderTableViewCell else { return UITableViewCell() }
            
            cell.designLabels()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            
            cell.backgroundColor = .clear
            cell.designLabels()
    //        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
    //        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"
            cell.updateLabelTexts(data: list[indexPath.row - 1])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 24
        } else {
            return 44
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        requestBoxOffice(text: searchBar.text!)  // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인지 등 확인 필요
        requestBoxOffice(text: searchBar.text!)
    }
}
