//
//  BoxOfficeModel.swift
//  Network
//
//  Created by SC on 2022/08/02.
//

import Foundation

struct BoxOfficeModel {
    let rank: String
    let movieTitle: String
    let releaseDate: String
    let totalCount: String  // 누적관객수
    let showCount: String   // 해당 일자 상영 횟수
}
