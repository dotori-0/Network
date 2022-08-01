//
//  ReusableViewProtocol.swift
//  Network
//
//  Created by SC on 2022/08/01.
//

import UIKit

protocol ReusableViewProtocol {
    static var resueIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol {  // extension 저장 프로퍼티 불가능 -> 그래서 저장프로퍼티의 형태로 프로토콜의 프로퍼티가 뜨게 됨
    static var resueIdentifier: String {  // 연산 프로퍼티 get만 사용한다면 get 생략 가능
        return String(describing: self)
//        get {
//            return String(describing: self)
//        }
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var resueIdentifier: String {
        return String(describing: self)  // 자기 자신의 클래스를 스트링으로 만들어 준다
    }
}