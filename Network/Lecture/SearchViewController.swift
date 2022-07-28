//
//  SearchViewController.swift
//  Network
//
//  Created by SC on 2022/07/27.
//

import UIKit

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔  // 🕘 2:35:00
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 
 */


extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = .red
    }
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var second: UITableView!
    @IBOutlet weak var third: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰에 delegate와 dataSource 연결
        // 연결고리 작업: 테이블뷰가 해야할 역할 > 뷰컨트롤러에게 요청
        searchTableView.delegate = self  // self: SearchViewController의 인스턴스
        searchTableView.dataSource = self
        
        // 테이블뷰가 사용할 테이블뷰 셀 등록
        // XIB: Xml Interface Builder <= 예전에는 Nib이라는 파일을 사용했음
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func configureLabel(text: String) {
        return
    }
    

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            Method does not override any method from its superclass
//      UITableViewController 라면 재정의가 맞지만, UIViewController 상속이기 때문에 재정의 X
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "HELLO"
        
        return cell
    }
}
