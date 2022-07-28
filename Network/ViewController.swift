//
//  ViewController.swift
//  Network
//
//  Created by SC on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol {
    
    
    static var identifier: String = "ViewController"
    
    var navigationTitleString: String = "대장님의 다마고치"  // 혹은
//    var navigationTitleString: String {  // 연산 프로퍼티로도 사용 가능. 단, 프로토콜의 최소 요건을 충족해야 함
//        // navigationTitleString은 { get set } 이므로 get과 set 둘 다 구현해야 함
//        get {
//            return "대장님의 다마고치"
//        }
//        set {
//            title = newValue
//        }
//    }
    
//    let backgroundColor: UIColor = .blue
//    var backgroundColor: UIColor = .blue
    var backgroundColor: UIColor {  // 연산 프로퍼티로도 사용 가능. 단, 프로토콜의 최소 요건을 충족해야 함
        // backgroundColor는 { get }이기 때문에 get만 구현해도 됨 (set도 구현해도 됨)
        get {
            return .blue
        }
    }
    
    
    func configureView() {
        
        navigationTitleString = "고래밥님의 다마고치"
//        backgroundColor = .red  // 프로토콜에서 get만 명시한 것이 최소기능이기 때문에 set도 구현해도 괜찮다
        
//        view.backgroundColor = .blue
        title = navigationTitleString
        view.backgroundColor = backgroundColor
        
//        backgroundColor = .red
        // backgroundColor를 프로토콜 선언에서는 get만, 클래스에서도 get만 구현할 경우 set 불가 (값 넣기 불가)
        // 프로토콜 선언에서 get만 지정해 주더라도, 클래스에서 set까지 지정해 주거나 아예 연산 프로퍼티로 사용하지 않으면 값 넣기 가능
    }
    
    func configureLabel(text: String) {
        return
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

