//
//  TranslateViewController.swift
//  Network
//
//  Created by SC on 2022/07/28.
//

import UIKit

// UIButton, UITextField > Action 연결 가능
// UITextView, UISearchBar, UIPickerView > 액션 연결 불가능
// UIControl 때문
// UIResponderChain > resignFirstResponder() / becomeFirstResponder()

class TranslateViewController: UIViewController {

    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 입력해 주세요"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        userInputTextView.placeholder = "번역하고 싶은 문장을 입력해 주세요"
        
        userInputTextView.delegate = self
        
        // 한 번 찾아보기
        userInputTextView.becomeFirstResponder()
        userInputTextView.resignFirstResponder()
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
    }
    
    

}

extension TranslateViewController: UITextViewDelegate {
    // 텍스트뷰의 텍스트가 변할 때마다 호출 (글자수 제한 등)
    func textViewDidChange(_ textView: UITextView) {  // 한 글자라도 변경되었을 때
        print(textView.text.count)
    }
    
    // 편집이 시작될 때 (커서가 깜빡이기 시작할 때)
    // 텍스트 뷰 글자: 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝났을 때 (커서가 없어지는 순간)
    // 텍스트 뷰 글자: 사용자가 아무 글자도 안 썼으면 placeholder 글자 보이게 해!
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        
        // textView.text는 옵셔널이 아니기 때문에 옵셔널 체이닝이나 예외처리 할 필요 없다!
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}
