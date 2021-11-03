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
  
  private var accessoryBar : UIToolbar = {

    let toolbar = UIToolbar()

    toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                      UIBarButtonItem.init(title: "확인",
                                           style: .done,
                                           target: self,
                                           action: #selector(didTapDoneButton))], animated: true)
    
    toolbar.barStyle = UIBarStyle.default
    toolbar.isTranslucent = true
    toolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    toolbar.sizeToFit()
    
    return toolbar
  }()
  
  @IBOutlet weak var targetDateLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet var drawtNumberLabelList: [UILabel]! {
    didSet {
      drawtNumberLabelList.forEach { label in
        label.backgroundColor = .lightGray
        

      }
    }
  }
  
  
  // 지금까지 진행된 회차
  private var lattestDrawNumber: Int = 986
  
  private var targetDrwNumber: Int = 0 {
    didSet {
      titleLabel.text = "\(targetDrwNumber)회 당첨 결과"
    }
  }
  
  private var targetDate: String = "" {
    didSet {
      targetDateLabel.text = targetDate
    }
  }
  
  
  private var targetDrwtNumberDataList: [Int] = [] {
    
    didSet {
      targetDrwtNumberDataList.enumerated().forEach { (index, number) in
        
        guard index < drawtNumberLabelList.count else { return }
        
        drawtNumberLabelList[index].text = "\(number)"
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 가장 최근회차 조회
    // 요청 파라미터 값 뭘로 보내야할지 검색해야하는데 시스템 점검중..
    fetchDrwtNumber(with: lattestDrawNumber)
    
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
   원하는 회차가 있는 경우
   */
  private func fetchDrwtNumber(with targetDraw: Int) {
    
    let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(targetDraw)"
    
    AF.request(url, method: .get).validate().responseJSON { [weak self] response in
    
        switch response.result {
    
        case .success(let value):
            
            let json = JSON(value)
            
            self?.targetDate = json["drwNoDate"].stringValue
            
            self?.targetDrwNumber = json["drwNo"].intValue
            
            var drwtNumList = [Int]()
            
            for number in (1...6) {
              
              drwtNumList.append(json["drwtNo\(number)"].intValue)
            }
            
            self?.targetDrwtNumberDataList = drwtNumList
    
        case .failure(let error):
            
            print(error.localizedDescription)
        }
    }
  }
  
  private func setUpDrawNumberTextField() {
    
    drawNumberTextField.inputView = drawNumberPicker
    drawNumberTextField.inputAccessoryView = accessoryBar
  }
  
  private func setUpDrawNumberPicker() {
    
    drawNumberPicker.delegate = self
    drawNumberPicker.dataSource = self
  }
  
  @objc func didTapDoneButton() {
    
    let targetDrwNo = lattestDrawNumber - drawNumberPicker.selectedRow(inComponent: 0)
    
    fetchDrwtNumber(with: targetDrwNo)
    
    drawNumberTextField.resignFirstResponder()
  }

}

extension LotteryViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    return lattestDrawNumber
  }
}

extension LotteryViewController: UIPickerViewDelegate {
  
  /*
  회차를 역순으로 보여주기
   */
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    guard (0...lattestDrawNumber-1).contains(row) else { return "" }

    let targetIndex = row

    return "\((1 ... lattestDrawNumber).reversed()[targetIndex])"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//    fetchDrwtNumber(with: lattestDrawNumber - row)
  }
}
