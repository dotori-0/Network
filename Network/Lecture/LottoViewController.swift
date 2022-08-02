//
//  LottoViewController.swift
//  Network
//
//  Created by SC on 2022/07/28.
//

import UIKit  // 애플 내부 프레임워크 먼저
// 1. import
import Alamofire  // 엔터치고 외부 프레임워크 알파벳 순서대로
import SwiftyJSON


class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    @IBOutlet var winningNumberLabels: [UILabel]!
    
    var lottoPickerView = UIPickerView()
    // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음!!
    
    let numberList: [Int] = Array(1...1025).reversed()
    var winningNumbers: [Int] = []
    
    let winningNumberKeys = ["drwtNo1", "drwtNo2", "drwtNo3", "drwtNo4", "drwtNo5", "drwtNo6", "bnusNo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        numberTextField.textContentType = .oneTimeCode  // 인증번호 자동완성
        
        numberTextField.inputView = lottoPickerView  // 가장 쉽게 키보드 안 나오게 하는 방법
        numberTextField.tintColor = .clear
        
        numberTextField.delegate = self
        
        requestLotto(number: 1025)
    }
    
    func requestLotto(number: Int) {
        winningNumbers.removeAll()
        
        // AF: 200~299 status code - success
        let url = "\(Endpoint.lotteryURL)&drwNo=\(number)"
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in  // Alamofire에서 AF로 바뀜
            switch response.result {
                case .success(let value):
                    print("==3==")
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let bonus = json["bnusNo"].intValue
                    let date = json["drwNoDate"].stringValue
                    print(bonus, date)
                    
                    for key in self.winningNumberKeys {
                        self.winningNumbers.append(json[key].intValue)
                    }
                    
                    print(self.winningNumbers)
                    
                    self.updateWinningNumberLabels()
                    
                    print("==4==")
                    self.numberTextField.text = date
                    print("==5==")
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func updateWinningNumberLabels() {
        for i in 0..<winningNumbers.count {
            winningNumberLabels[i].text = "\(winningNumbers[i])"
        }
    }
    
    @IBAction func textFieldTouchedDown(_ sender: UITextField) {
        numberTextField.isSelected = false
    }
}


// 보통은 객체들마다 필요한 delegate들을 extension으로 빼서 관리한다
// 주로 현업에서는 파일을 따로 빼지 않고 클래스 하단에 작성한다
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return component == 0 ? 10 : 20
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(component, row)
        print("==0==")
        requestLotto(number: numberList[row])
        print("==1==")
        numberTextField.text = "\(numberList[row])회차"
        print("==2==")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}


extension LottoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        numberTextField.isUserInteractionEnabled = false
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        numberTextField.isUserInteractionEnabled = true
    }
}
