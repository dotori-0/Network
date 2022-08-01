//
//  UserDefaultsHelper.swift
//  Network
//
//  Created by SC on 2022/08/01.
//

import Foundation

class UserDefaultsHelper {  // UserDefaults가 class라서 타입 맞춰 줌
    
    private init() { }  // 외부에서 인스턴스 생성 불가하게  // 다 static 변수로 하는거랑 뭐가 다른지?
    
    static let standard = UserDefaultsHelper()
    // Singleton Pattern: 자기 자신의 인스턴스를 타입 프로퍼티 형태로 가짐
    // 타입 프로퍼티는 한 번 호출되면 앱을 종료할 때까지 메모리에 계속 남아있음
    // shared나 standard, default(UserDefaults 클래스 안에 standard 있음)
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case nickname, age
    }
    
//    var nickname: String? {  // 방법 1  // 이렇게 하면 ..?
    var nickname: String {  // 방법 2
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {  // 연산 프로퍼티 parameter
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)  // 기본값이 0
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
