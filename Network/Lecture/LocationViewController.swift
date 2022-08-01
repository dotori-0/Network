//
//  LocationViewController.swift
//  Network
//
//  Created by SC on 2022/07/29.
//

import UIKit

//class LocationViewController: UIViewController, ReusableViewProtocol {
class LocationViewController: UIViewController {
    
//    static var resueIdentifier: String = String(describing: LocationViewController.self)
    //LocationViewController.self 메타 타입 => "LocationViewController"

    // Notification 1.
    // UN - User Notification
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom Font
        // 폰트 네임 확인하는 코드
        for family in UIFont.familyNames {
            print("=====\(family)=====")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }

        requestAuthorization()
    }
    
    // Notification 2. 권한 요청
    func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success {
                // 함수 안에 함수가 있으므로, 명확하게 클래스의 함수를 사용하라는 의미로 self.를 붙여야 함
                self.sendNotification()
            }
        }
    }
    
    // Notification 3. 권한을 허용한 사용자에게 알림 전송(언제? 어떤 컨텐츠?)
    // iOS 시스템에서 알림을 담당한다 > 알림 등록하는 코드 필요
    
    
    /*
     - 권한 허용 해야만 알림이 온다.
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다.
     - 허용 안 된 경우 애플 설정으로 직접 유도하는 코드를 구성해야 한다.
     
     - 기본적으로 알림은 포그라운드에서 수신되지 않는다. (수신하려면 AppDelegate에서 설정)
     - 로컬 알림에서 간격이 60초 이상이어야 반복 가능 / 갯수 제한 64개 / 커스텀 사운드 30초까지만 (아마도)
     
     
     1. 뱃지 제거? > 언제 제거하는 게 맞을까? (active 상태에 따라 주로 제거)
     2. 노티 제거? > 노티의 유효 기간은? 카톡(오픈채팅, 단톡) vs 잔디 > 언제 삭제해 주는 게 맞을까?
     3. 포그라운드 수신? > 델리게이트 메서드로 해결!
     
     + a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
     - 포그라운드 수신 > 특정화면에서는 안받고, 특정 조건에 대해서만 포그라운드 수신을 하고 싶다면?
     이런 것들을 앞으로 더 배우게 될 것 같다
     - iOS 15 집중모드 등 5~6개의 우선순위 존재!
     */
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "다마고치를 키워 보세요??"
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))입니다"
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요."
        // ➕ body 없이 title이랑 subtitle만 있으면 subtitle이 body 자리에 뜸
        notificationContent.badge = 40
        
        // 언제 보낼 것인가? 옵션 -  1. 시간 간격 2. 캘린더 3. 위치에 따라
        // 시간 간격은 60초 이상 설정해야 반복 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // 캘린더
//        var dateComponent = DateComponents()
//        dateComponent.minute = 59 // 매 시각 몇 분에 오게 하는지
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // 알림 요청
        // identifier
        // 만약 알림 관리할 필요 X -> 알림 클릭하면 앱을 켜주는 정도
        // 만약 알림 관리할 필요 O -> + 1 하거나, 고유 이름, 규칙 등
        let request = UNNotificationRequest(identifier: "sani", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        sendNotification()
    }
}
