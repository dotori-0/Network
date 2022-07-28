//
//  ViewPresetableProtocol.swift
//  Network
//
//  Created by SC on 2022/07/28.
//

import Foundation
import UIKit

/*
네이밍:
 ~~~~Protocol
 ~~~~Delegate
 
 
*/

// 프로토콜은 규약이자 필요한 요소를 명세만 할 뿐, 실질적인 구현부는 작성하지 않는다!
// 실질적인 구현은 프로토콜을 채택, 준수하는 타입이 구현한다!
// 클래스, 구조체, 익스텐션, 열거형...에서 사용이 가능하다
// 클래스는 단일 상속만 가능하지만, 프로토콜은 채택 갯수에 제한이 없다!
// @objc optional > 선택적 요청(Optional Requirement)
// 프로토콜 프로퍼티, 프로토콜 메서드

// 프로토콜 프로퍼티: 연산 프로퍼티로 쓰든, 저장 프로퍼티로 쓰든 상관하지 않는다! 명세하지 않기에,
// 구현을 할 때 프로퍼티를 저장 프로퍼티로 쓸 수도 있고 연산 프로퍼티로 사용할 수도 있다.
// 무조건 var로 선언해야 한다.
// 만약 get을 명시했다면 get 기능만 최소한 구현되어 있으면 된다! 그래서 필요하다면 set도 구현해도 괜찮다.
@objc
protocol ViewPresentableProtocol {
    
    var navigationTitleString: String { get set }
    var backgroundColor: UIColor { get }  // get만 명시하면, 프로토콜을 채택한 클래스에서 let으로 선언할 수 있다
    static var identifier: String { get }  // get만 명시하면, 프로토콜을 채택한 클래스에서 let으로 선언할 수 있다
    
    func configureView()
    @objc optional func configureLabel(text: String)
    @objc optional func configureTextField()
}


/*
 ex. 테이블뷰
*/

@objc protocol SaniTableViewProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    @objc optional func didSelectRowAt()
}
