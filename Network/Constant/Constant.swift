//
//  Constant.swift
//  Network
//
//  Created by SC on 2022/08/01.
//

import Foundation


struct Endpoint {  // URL을 EndPoint라고 하기도 한다
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lotteryURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
}


//enum StoryboardName {
//    case Main
//    case Search
//    case Setting
//}
// StoryboardName.Main.rawValue  // 사용할 때 길다

// 그래서 구조체로 만드는 경우도 있다
struct StoryboardName {
    
    // 접근제어를 통해 초기화 방지
    // 5가지 단계 중 가장 코드를 사용할 수 있는 범위가 작은 것이 private
    // 다른 파일에서는 사용하지 못하고 내부에서만 사용 가능
    // 인스턴스 생성 불가
    // 이렇게 하면 열거형을 쓰는 것과 구조체를 쓰는 것의 차이가 별로 없게 된다
    private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}
// StoryboardName.search  // 더 짧게 사용 가능

// 열거형을 쓰는 게 더 적합할 수도 있다

/*
 1. struct type property vs enum type property => 인스턴스 생성 방지의 차이점이 있다
 (열거형은 초기화 불가)
 2. enum case vs enum static => 중복, case 제약(UIColor 등을 넣기 어렵다)
 */

// 열거형에 타입 프로퍼티 만들기
// 공통된 상수를 사용할 때 가장 적합한 방법
//enum StoryboardName {
////    var nickname = "고래밥"  // 인스턴스를 만들지 못해서
////    static var nickname = "고래밥"  // 가능
//
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//}

enum FontName {
//    case title = "SanFrancisco"
//    case body = "SanFrancisco"  // Raw value for enum case is not unique 중복 불가
//    case caption = "AppleSandol"
    // 스트링, 더블 같은 것만 가능하고 UIColor같은 건 넣기 힘들다
    
    static let title = "SanFrancisco"
    static let body = "SanFrancisco"  // Raw value for enum case is not unique
    static let caption = "AppleSandol"
}
