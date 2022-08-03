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

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchImage()
    }
    
    // fetch, request, callRequest, get,... > response에 따라 네이밍을 하기도 한다 > 언제 뭘 쓰는지 찾아보기
    // 내일 > 페이지네이션
    func fetchImage() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 옵셔널이기 때문에 타입 어노테이션이나 가드구문 등으로 처리
        let url = Endpoint.imageSearchURL + "query=\(text)&display=30&start=1"  // 왜 한글만 안 될까?
        
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                case .failure(let error):
                    print(error)
            }
        }
    }

}
