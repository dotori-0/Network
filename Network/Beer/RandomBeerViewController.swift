//
//  RandomBeerViewController.swift
//  Network
//
//  Created by SC on 2022/08/02.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class RandomBeerViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestRandomBeer()
    }
    
    func requestRandomBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
//        AF.request(url, method: .get).validate().responseDecodable {
        AF.request(url, method: .get).validate().responseJSON {
            response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)[0]
                    let name = json["name"].stringValue
                    let imageURL = json["image_url"].string
                    let description = json["description"].stringValue
                    
                    let defaultImageURL = "https://cdn-icons.flaticon.com/png/512/2977/premium/2977173.png?token=exp=1659369480~hmac=95a5a73c533cc76f4b3dabfebe8cb3e4"
                    
                    self.updateView(name: name, imageURL: imageURL ?? defaultImageURL, description: description)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func updateView(name: String, imageURL: String, description: String) {
        nameLabel.text = name
        
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
        
        descriptionTextView.text = description
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        requestRandomBeer()
    }
    
//    func requestLotto(number: Int) {
//        // AF: 200~299 status code - success
//        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
//        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in  // Alamofire에서 AF로 바뀜
//            switch response.result {
//            case .success(let value):
//                print("==3==")
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                let bonus = json["bnusNo"].intValue
//                print(bonus)
//
//                let date = json["drwNoDate"].stringValue
//                print(date)
//
//                print("==4==")
//                self.numberTextField.text = date
//                print("==5==")
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}
