//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Woochan Park on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON

final class LotteryViewController: UIViewController {

  // 회차를 선택할 수 있는 텍스트필드
  @IBOutlet private weak var drawNumberTextField: UITextField!
  
  // 텍스트 필드의 인풋뷰
  private let drawNumberPicker: UIPickerView = {
    
    let pickerView = UIPickerView()

    return pickerView
  }()
  
  @IBOutlet var drawtNumberLabelList: [UILabel]! {
    didSet {
      drawtNumberLabelList.forEach { label in
        label.backgroundColor = .lightGray
        

      }
    }
  }
  
  
  // 지금까지 진행된 회차
  private var totalDrawNumber: Int = 300
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 가장 최근회차 조회
    // 요청 파라미터 값 뭘로 보내야할지 검색해야하는데 시스템 점검중..
    fetchDrwtNumber()
    
    setUpDrawNumberTextField()
    
    setUpDrawNumberPicker()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    drawtNumberLabelList.forEach { label in
      
      label.layer.masksToBounds = true
      label.layer.cornerRadius = label.frame.height / 2
    }
  }
  
  /**
   "drwtNo2": 10,
   "drwtNo3": 16,
   "drwtNo1": 7
   등으로 응답값이 와서 drwt 로 작명
   */
  private func fetchDrwtNumber() {
    
//    let url = 
//    
//    Alamofire.request(url, method: .get).validate().responseJSON { response in
//        switch response.result {
//        case .success(let value):
//            let json = JSON(value)
//            print("JSON: \(json)")
//        case .failure(let error):
//            print(error)
//        }
//    }
    
    // TODO: 응답 값으로 초기화 필요
//    totalDrawNumber = 0
  }
  
  private func setUpDrawNumberTextField() {
    drawNumberTextField.inputView = drawNumberPicker
    drawNumberTextField.delegate = self
  }
  
  private func setUpDrawNumberPicker() {
    
    drawNumberPicker.delegate = self
    drawNumberPicker.dataSource = self
  }

}


extension LotteryViewController: UITextFieldDelegate {
  
}

extension LotteryViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    return totalDrawNumber
  }
}

extension LotteryViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    return "\(row + 1)"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    let drawNumber = row + 1
    
    print(drawNumber)
    // TODO:
  }
}
