//
//  TestSurveyController.swift
//  Mohae
//
//  Created by 이주영 on 02/10/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import Foundation
import Firebase
// 1. 커플? -> YES/NO => 2개
// 2. 함께하는 인원은 몇 명인가요? -> 1 ~ 2명/ 3 ~ 5명/ 6명 이상 => 3 개
// 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
// 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
// 5. 현재 기분은 어떤가요? -> 행복, 슬픔, 차분, 흥분 등 => 4 개 이상
// 총 필요한 버튼 수는 최소 16개
// 한 질문에 사용하는 최대 버튼 수는 5 개
class TestSurveyController: UIViewController {
    
    var subSurveys = [SubSurvey]()
    var questions: [String] = ["질문 1", "질문 2", "질문 3", "질문 4", "질문 5"]
    var buttonText: [[String]] = [
                                    ["YES", "NO"],
                                    ["1 ~ 2 명", "3 ~ 5 명", "6 명 이상"],
                                    ["무료", "1 만 원 ~ 5 만 원", "6 먼 원 ~ 10 만 원", "10 만 원 이상"],
                                    ["맑음", "흐림", "비", "눈", "자연재해"],
                                    ["행복", "슬픔", "차분", "흥분"]
                                 ]
    var subSurveyViews = [UIView]()
    var buttons = [UIButton]()
    var questionText = [UITextField]()
    
    var slideWidth : CGFloat = 0
    var rightConstraints: NSLayoutConstraint?
    //let timestamp = NSDate().timeIntervalSince1970

    func makeView() -> UIView {
        let surveyView = UIView()
        surveyView.translatesAutoresizingMaskIntoConstraints = false
        
        return surveyView
    }
    
    func makeButton() -> UIButton {
        let answerButton = UIButton(type: .system)
        answerButton.translatesAutoresizingMaskIntoConstraints = false
        
        return answerButton
    }
    
    func makeTextField() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.isEnabled = false
        
        return tf
    }
    
    let completeText: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isEnabled = false
        tf.text = "완료..."
        
        return tf
    }()
    
    @objc func moveToNextView() {
        print("click!!")
        if rightConstraints?.constant == 0 { // 화면에 나와있을 때
            rightConstraints?.constant = -slideWidth // 다시 왼쪽으로 보냄
        } else { // 화면에 없을 때
            rightConstraints?.constant = 0 // 화면에 올림
        }
        
        UIView.animate(withDuration: 0.4){
            self.view.layoutIfNeeded()
        }
    }
    
    func setSubSurveyView() {
        view.backgroundColor = .white
        
        for question in questions { // view와 textfield 5 개 생성
            subSurveyViews.append(makeView()) // 5 개 생성
            questionText.append(makeTextField()) // 5 개 생성
        }
        
        for btnNumber in 0 ... 17 {
            buttons.append(makeButton())
        }
        
        for i in (0 ... 4).reversed() {
            view.addSubview(subSurveyViews[i])
        }
        
        for index in 0 ... 4 {
            subSurveyViews[index].backgroundColor = .white
            //질문지 view 위치 설정
            subSurveyViews[index].snp.makeConstraints { (make) in
                make.width.equalTo(slideWidth)
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(view.snp.bottom)
            }
            
            rightConstraints = subSurveyViews[index].leftAnchor.constraint(equalTo: view.leftAnchor)
            rightConstraints?.isActive = true
            
            subSurveyViews[index].addSubview(questionText[index])
            
            questionText[index].snp.makeConstraints { (make) in
                make.centerX.equalTo(subSurveyViews[index].snp.centerX)
                make.centerY.equalTo(subSurveyViews[index].snp.centerY)
            }
            
            questionText[index].text = questions[index]
            
            // 버튼 16 개 생성 이후 해당 index의 view에 버튼 추가 및 위치 설정
            switch index {
            case 0 : // 1. 커플? -> YES/NO => 2개
                subSurveyViews[index].addSubview(buttons[0]) // YES
                subSurveyViews[index].addSubview(buttons[1]) // NO
                
                buttons[0].setTitle(buttonText[index][0], for: .normal)
                buttons[1].setTitle(buttonText[index][1], for: .normal)
                
                buttons[0].snp.makeConstraints { (make) in
                    make.top.equalTo(questionText[index].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[1].snp.makeConstraints { (make) in
                    make.top.equalTo(buttons[0].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[0].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                buttons[1].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
            case 1 : // 2. 함께하는 인원은 몇 명인가요? -> 1 ~ 2명/ 3 ~ 5명/ 6명 이상 => 3 개
                for num in 2 ... 4 {
                    subSurveyViews[index].addSubview(buttons[num])
                    buttons[num].setTitle(buttonText[index][num - 2], for: .normal)
                }
                
                buttons[2].snp.makeConstraints { (make) in
                    make.top.equalTo(questionText[index].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[2].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                
                for i in 3 ... 4 {
                    buttons[i].snp.makeConstraints { (make) in
                        make.top.equalTo(buttons[i - 1].snp.bottom)
                        make.centerX.equalTo(view.snp.centerX)
                    }
                    
                    buttons[i].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                }
                
            case 2 : // 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
                for num in 5 ... 8 {
                    subSurveyViews[index].addSubview(buttons[num])
                    buttons[num].setTitle(buttonText[index][num - 5], for: .normal)
                }
                
                buttons[5].snp.makeConstraints { (make) in
                    make.top.equalTo(questionText[index].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[5].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                
                for num in 6 ... 8 {
                    buttons[num].snp.makeConstraints { (make) in
                        make.top.equalTo(buttons[num - 1].snp.bottom)
                        make.centerX.equalTo(view.snp.centerX)
                    }
                    
                    buttons[num].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                }
                
            case 3 : // 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
                for num in 9 ... 13 {
                    subSurveyViews[index].addSubview(buttons[num])
                    buttons[num].setTitle(buttonText[index][num - 9], for: .normal)
                }
                
                buttons[9].snp.makeConstraints { (make) in
                    make.top.equalTo(questionText[index].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[9].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                
                for num in 10 ... 13 {
                    buttons[num].snp.makeConstraints { (make) in
                        make.top.equalTo(buttons[num - 1].snp.bottom)
                        make.centerX.equalTo(view.snp.centerX)
                    }
                    
                    buttons[num].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                }
                
            case 4 : // 5. 현재 기분은 어떤가요? -> 행복, 슬픔, 차분, 흥분 등 => 4 개 이상
                for num in 14 ... 17 {
                    subSurveyViews[index].addSubview(buttons[num])
                    buttons[num].setTitle(buttonText[index][num - 14], for: .normal)
                }
                
                buttons[14].snp.makeConstraints { (make) in
                    make.top.equalTo(questionText[index].snp.bottom)
                    make.centerX.equalTo(view.snp.centerX)
                }
                
                buttons[14].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                
                for num in 15 ... 17 {
                    buttons[num].snp.makeConstraints { (make) in
                        make.top.equalTo(buttons[num - 1].snp.bottom)
                        make.centerX.equalTo(view.snp.centerX)
                    }
                    
                    buttons[num].addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
                }
            default:
                break
            }
        }
    }
    
    @objc func goBack() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        
        slideWidth = view.frame.width
        
        view.addSubview(completeText)
        completeText.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        setSubSurveyView()
    }
}
